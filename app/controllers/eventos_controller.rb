# app/controllers/eventos_controller.rb

class EventosController < ApplicationController
  before_action :set_evento, only: %i[ show update destroy ]

  # GET /eventos
  def index
    if params[:autor_id].present?
      # EAGER LOADING: Carrega eventos E seus autores em apenas 2 queries
      # Evita o problema N+1 (1 query para eventos + N queries para autores)
      @eventos = Evento.where(autor_id: params[:autor_id]).includes(:autor, :imagem)
    else
      # Inclui todos os autores antecipadamente para otimização
      @eventos = Evento.all.includes(:autor, :imagem)
    end
    # Inclui dados do autor na resposta JSON
    # SEM eager loading: retorna apenas autor_id
    # COM eager loading: retorna autor: {id: X, nome: "Nome"}
    render json: @eventos.as_json(
      include: {
        autor: { only: [:id, :nome]},
        imagem: { only: [:url_imagem, :creditos, :descricao] }
      }
    )
  end

  # GET /eventos/1
  def show
    # EAGER LOADING: Já carregou o autor via before_action + includes
    # Retorna dados completos do evento incluindo informações do autor
    render json: @evento.as_json(
      include: {
        autor: { only: [:id, :nome]},
        imagem: { only: [:url_imagem, :creditos, :descricao] }
      }
    )
  end

  # POST /eventos
  def create
    uploaded_image = params[:imagem]

    image_url = nil
    if uploaded_image.present?
      result = Cloudinary::Uploader.upload(uploaded_image, folder: "eventos", public_id: SecureRandom.uuid)
      
      image = Imagem.new(
        cloud_id: result["public_id"], # Agora armazenamos o public_id
        url_imagem: result["secure_url"],
        creditos: evento_params[:creditos_imagem], # Usando os novos parametros
        descricao: evento_params[:alt_imagem] # Usando os novos parametros
      )

      unless image.save
        return render json: { imagem_errors: image.errors }, status: :unprocessable_entity
      end

    end
    # Removendo os campos que não existem em eventos
    evento_attrs = evento_params.except(:creditos_imagem, :alt_imagem)

    @evento = Evento.new(evento_attrs)
    @evento.imagem = image if image.present? # Associa o objeto Imagem
    if @evento.save
      # Inclui dados do autor na resposta
      render json: @evento.as_json(include: { autor: { only: [:id, :nome] } }), status: :created, location: @evento
    else
      # Se falhar, tentamos deletar a imagem que já foi enviada (limpeza)
      image.destroy if image.present? && image.persisted?
      render json: @evento.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /eventos/1
  def update
    uploaded_image = params[:imagem]

    # Remove os campos de imagem do hash evento para o evento.update
    evento_attrs = evento_params.except(:creditos_imagem, :alt_imagem)
    
    image_to_destroy = nil
    image_to_create = nil

    if uploaded_image.present?
      if @evento.imagem.present?
        image_to_destroy = @evento.imagem
      end

      result = Cloudinary::Uploader.upload(uploaded_image, folder: "eventos", public_id: SecureRandom.uuid)
      image_to_create = Imagem.new(
        cloud_id: result["public_id"],
        url_imagem: result["secure_url"],
        creditos: evento_params[:creditos_imagem],
        descricao: evento_params[:alt_imagem]
      )

      unless image_to_create.save
        return render json: { imagem_errors: image_to_create.errors }, status: :unprocessable_entity
      end

      @evento.imagem = image_to_create
      
    elsif evento_params[:creditos_imagem].present? || evento_params[:alt_imagem].present?
      if @evento.imagem.present?
        @evento.imagem.update(
          creditos: evento_params[:creditos_imagem],
          descricao: evento_params[:alt_imagem]
        )
      end
    end

    if @evento.update(evento_attrs)
      if image_to_destroy.present?
        Cloudinary::Uploader.destroy(image_to_destroy.cloud_id)
        image_to_destroy.destroy
      end
      # Inclui dados do autor na resposta
      render json: @evento
    else
      image_to_create.destroy if image_to_create.present?
      render json: @evento.errors, status: :unprocessable_entity
    end
  end

  # DELETE /eventos/1
  def destroy
    imagem_a_deletar = @evento.imagem

    @evento.destroy!

    if imagem_a_deletar.present?
      Cloudinary::Uploader.destroy(imagem_a_deletar.cloud_id)
      imagem_a_deletar.destroy!
    end
    head :no_content
  end

private

  def set_evento
    @evento = Evento.find(params[:id])
  end

  def evento_params
    # 💥 MUDANÇA CRUCIAL: Adicionar os novos campos da imagem
    permitidos = [:titulo, :conteudo, :local, :data, :autor_id, :status, tags: []]
    permitidos << :creditos_imagem 
    permitidos << :alt_imagem

    params.require(:evento).permit(permitidos)
  end

  def extract_public_id(url)
    return nil unless url.present?
    
    parts = url.split("/upload/").last.split("/")
    parts.shift if parts.first.start_with?("v")
    public_id_with_ext = parts.join("/")
    public_id = public_id_with_ext.sub(File.extname(public_id_with_ext), "")
    public_id
  end
end
#ajustando