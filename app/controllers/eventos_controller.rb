class EventosController < ApplicationController
  before_action :set_evento, only: %i[ show update destroy ]

  # GET /eventos
  def index
    if params[:autor_id].present?
      @eventos = Evento.where(autor_id: params[:autor_id])
    else
      @eventos = Evento.all
    end
    render json: @eventos
  end

  # GET /eventos/1
  def show
    render json: @evento.as_json(except: [:created_at, :updated_at])
  end

  # POST /eventos
  def create
    uploaded_image = params[:imagem]
    
    image_url = nil
    if uploaded_image.present?
      begin
        result = Cloudinary::Uploader.upload(uploaded_image, folder: "eventos", public_id: SecureRandom.uuid)
        image_url = result["secure_url"]
      rescue CloudinaryException => e
        render json: { error: "Erro ao fazer upload da imagem: #{e.message}" }, status: :unprocessable_entity and return
      end
    end

    @evento = Evento.new(evento_params.merge(url_imagem: image_url))

    if @evento.save
      render json: @evento.as_json(except: [:created_at, :updated_at]), status: :created, location: @evento
    else
      render json: @evento.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /eventos/1
  def update
    uploaded_image = params[:evento][:imagem_capa]
    image_url = nil

    if uploaded_image.present?
      # O limite de tamanho de arquivo foi removido deste bloco.
      
      # Lógica para remover imagem antiga, seguindo o padrão ArtigosController
      if @evento.url_imagem.present?
        public_id = extract_public_id(@evento.url_imagem)
        Cloudinary::Uploader.destroy(public_id)
      end

      # Faz upload da nova imagem
      begin
        result = Cloudinary::Uploader.upload(uploaded_image, folder: "eventos", public_id: SecureRandom.uuid)
        image_url = result["secure_url"]
      rescue CloudinaryException => e
        render json: { error: "Erro ao fazer upload da nova imagem: #{e.message}" }, status: :unprocessable_entity and return
      end
    end

    update_params = evento_params
    
    # Adiciona a url_imagem somente se um novo upload ocorreu
    update_params = update_params.merge(url_imagem: image_url) if image_url.present?

    if @evento.update(update_params)
      render json: @evento.as_json(except: [:created_at, :updated_at])
    else
      render json: @evento.errors, status: :unprocessable_entity
    end
  end

  # DELETE /eventos/1
  def destroy
    # Lógica de remoção de imagem do Cloudinary
    if @evento.url_imagem.present?
      public_id = extract_public_id(@evento.url_imagem)
      Cloudinary::Uploader.destroy(public_id)
    end
    
    @evento.destroy!
    head :no_content
  end

  private
    def set_evento
      @evento = Evento.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Evento não encontrado" }, status: :not_found
    end

    def evento_params
      params.require(:evento).permit(
        :titulo, 
        :conteudo, 
        :status,
        :data, 
        :local, 
        :autor_id, 
        :imagem_capa, # Permite o arquivo de upload para evitar o erro de parâmetro não permitido
        tags: []
      )
    end
    
    # Método auxiliar para extrair o public_id da URL (copiado do ArtigosController)
    def extract_public_id(url)
      # Pega tudo depois de "upload/" e remove versão (ex: v123456)
      parts = url.split("/upload/").last.split("/")
      parts.shift if parts.first.start_with?("v") # remove o "v12345"
      public_id_with_ext = parts.join("/")        # eventos/uuid.png
      public_id = public_id_with_ext.sub(File.extname(public_id_with_ext), "") # remove extensão
      public_id
    end
end