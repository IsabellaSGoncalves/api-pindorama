class EventosController < ApplicationController
  before_action :set_evento, only: %i[ show update destroy ]

  # GET /eventos
  def index
    if params[:autor_id].present?
      # EAGER LOADING: Carrega eventos E seus autores em apenas 2 queries
      # Evita o problema N+1 (1 query para eventos + N queries para autores)
      @eventos = Evento.where(autor_id: params[:autor_id]).includes(:autor)
    else
      # Inclui todos os autores antecipadamente para otimização
      @eventos = Evento.all.includes(:autor)
    end
    # Inclui dados do autor na resposta JSON
    # SEM eager loading: retorna apenas autor_id
    # COM eager loading: retorna autor: {id: X, nome: "Nome"}
    render json: @eventos.as_json(include: { autor: { only: [:id, :nome] } })
  end

  # GET /eventos/1
  def show
    # EAGER LOADING: Já carregou o autor via before_action + includes
    # Retorna dados completos do evento incluindo informações do autor
    render json: @evento.as_json(include: { autor: { only: [:id, :nome] } })
  end

  # POST /eventos
  def create
    uploaded_image = params[:imagem]

    image_url = nil
    if uploaded_image.present?
      result = Cloudinary::Uploader.upload(uploaded_image, folder: "eventos", public_id: SecureRandom.uuid)
      image_url = result["secure_url"]
    end

    @evento = Evento.new(evento_params.merge(url_imagem: image_url))

    if @evento.save
      # Inclui dados do autor na resposta
      render json: @evento.as_json(include: { autor: { only: [:id, :nome] } }), status: :created, location: @evento
    else
      render json: @evento.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /eventos/1
  def update
    uploaded_image = params[:imagem]

    if uploaded_image.present?
      if @evento.url_imagem.present?
        public_id = extract_public_id(@evento.url_imagem)
        Cloudinary::Uploader.destroy(public_id)
      end

      result = Cloudinary::Uploader.upload(uploaded_image, folder: "eventos", public_id: SecureRandom.uuid)
      image_url = result["secure_url"]

      if @evento.update(evento_params.merge(url_imagem: image_url))
        # Inclui dados do autor na resposta
        render json: @evento.as_json(include: { autor: { only: [:id, :nome] } })
      else
        render json: @evento.errors, status: :unprocessable_entity
      end
    else
      if @evento.update(evento_params)
        # Inclui dados do autor na resposta
        render json: @evento.as_json(include: { autor: { only: [:id, :nome] } })
      else
        render json: @evento.errors, status: :unprocessable_entity
      end
    end
  end

  # DELETE /eventos/1
  def destroy
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
  end

  def evento_params
    params.require(:evento).permit(:titulo, :conteudo, :local, :data, :autor_id, :status, tags: [])
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