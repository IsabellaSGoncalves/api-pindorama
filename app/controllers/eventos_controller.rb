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
    render json: @evento
  end

  # POST /eventos
  def create
    # mantive o imagem_capa porque é assim que é enviado do hook
    uploaded_image = params[:evento][:imagem_capa]

    image_url = nil
    if uploaded_image.present?
      # copiei na cara dura da Anahí esse trecho da imagem para o Cloudinary, incluindo a URL da imagem, é armazenado na variável `result`.
      result = Cloudinary::Uploader.upload(uploaded_image)
      
      # Extrai a URL do resultado do upload.
      image_url = result["secure_url"]
    end

    # O `evento_params` pega os dados como título, conteúdo, tags, etc...
    # Ajustado para usar urlImagemEvento: image_url
    @evento = Evento.new(evento_params.merge(urlImagemEvento: image_url))

    if @evento.save
      render json: @evento, status: :created, location: @evento
    else
      render json: @evento.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /eventos/1
  def update
  uploaded_image = params[:evento][:imagem_capa]
    image_url = nil

    if uploaded_image.present?
      result = Cloudinary::Uploader.upload(uploaded_image)
      image_url = result["secure_url"]
    end

    #parâmetros para a atualização.
    update_params = evento_params
    
    # Ajustado para usar urlImagemEvento: image_url
    update_params = update_params.merge(urlImagemEvento: image_url) if image_url.present?

    if @evento.update(update_params)
      render json: @evento
    else
      render json: @evento.errors, status: :unprocessable_entity
    end
  end

  # DELETE /eventos/1
  def destroy
    @evento.destroy!
  end

  private
    # O `set_evento` foi ajustado para `params[:id]`
    def set_evento
      @evento = Evento.find(params[:id])
    end

    # - `:imagem_capa` é um parâmetro permitido para que possamos acessar pelo controller antes de subir 
    # - `tagsEvento: []` recebe o array de tags
    def evento_params
      params.require(:evento).permit(
        :tituloEvento, 
        :conteudoEvento, 
        :dataEvento, 
        :localEvento, 
        :autorEvento, 
        :imagem_capa,
        tagsEvento: []
      )
    end
end