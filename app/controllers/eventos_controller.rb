# app/controllers/eventos_controller.rb

class EventosController < ApplicationController
  before_action :set_evento, only: %i[ show update destroy ]

  # GET /eventos
  def index
    if params[:autor_id].present?
      @eventos = Evento.where(autor_id: params[:autor_id])
    else
      @eventos = Evento.all
    end
    render json: @eventos.as_json(except: [:created_at, :updated_at])
  end

  # GET /eventos/1
  def show
    render json: @evento
  end

  # POST /eventos
  def create
    uploaded_image = params[:imagem]

    image_url = nil
    if uploaded_image.present? # Se uma imagem foi enviada
      # Dá upload na imagem e armazena os dados em result
      result = Cloudinary::Uploader.upload( uploaded_image, folder: "eventos", public_id: SecureRandom.uuid) # Alterado o folder para "eventos"
      # Pega a URL da imagem a partir do resultado do upload
      image_url = result["secure_url"]
    end
    # Cria um novo evento com os parametros
    @evento = Evento.new(evento_params.merge(url_imagem: image_url))

    if @evento.save
      render json: @evento, status: :created, location: @evento
    else
      render json: @evento.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /eventos/1
  def update
    uploaded_image = params[:imagem]

    if uploaded_image.present?
      # Se já existe imagem, remove a antiga
      if @evento.url_imagem.present?
        public_id = extract_public_id(@evento.url_imagem)
        Cloudinary::Uploader.destroy(public_id)
      end

      # Faz upload da nova imagem
      result = Cloudinary::Uploader.upload( uploaded_image, folder: "eventos", public_id: SecureRandom.uuid) # Alterado o folder para "eventos"
      image_url = result["secure_url"]

      # Atualiza com a nova URL
      if @evento.update(evento_params.merge(url_imagem: image_url))
        render json: @evento
      else
        render json: @evento.errors, status: :unprocessable_entity
      end
    else
      # Atualiza só os outros campos
      if @evento.update(evento_params)
        render json: @evento
      else
        render json: @evento.errors, status: :unprocessable_entity
      end
    end
  end

  # DELETE /eventos/1
  def destroy
    if @evento.url_imagem.present?
      # extrai o public_id da url
      public_id = extract_public_id(@evento.url_imagem)
      Cloudinary::Uploader.destroy(public_id)
    end

    @evento.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_evento
      @evento = Evento.find(params[:id]) # Corrigido para params[:id]
    end

    # Only allow a list of trusted parameters through.
    def evento_params
      params.require(:evento).permit(:titulo, :conteudo, :local, :data, :autor_id, :status)
    end

    # Método para extrair public_id de qualquer URL do Cloudinary
    def extract_public_id(url)
      # Pega tudo depois de "upload/" e remove versão (ex: v123456)
      parts = url.split("/upload/").last.split("/")
      parts.shift if parts.first.start_with?("v") # remove o "v12345"
      public_id_with_ext = parts.join("/")        # eventos/uuid.png
      public_id = public_id_with_ext.sub(File.extname(public_id_with_ext), "") # remove extensão
      public_id
    end
end