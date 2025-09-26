class ArtigosController < ApplicationController
  before_action :set_artigo, only: %i[ show update destroy ]

  # GET /artigos
  def index
    @artigos = Artigo.all

    render json: @artigos
  end

  # GET /artigos/1
  def show
    render json: @artigo
  end

  # POST /artigos
  def create
    uploaded_image = params[:imagem]

    image_url = nil
    if uploaded_image.present? # Se uma imagem foi enviada
      # Dá upload na imagem e armazena os dados em result
      result = Cloudinary::Uploader.upload(uploaded_image)
      # Pega a URL da imagem a partir do resultado do upload
      image_url = result["secure_url"]
    end
    # Cria um novo artigo com os parametros
    @artigo = Artigo.new(artigo_params.merge(url_imagem: image_url))

    if @artigo.save
      render json: @artigo, status: :created, location: @artigo
    else
      render json: @artigo.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /artigos/1
  def update
    if @artigo.update(artigo_params)
      render json: @artigo
    else
      render json: @artigo.errors, status: :unprocessable_entity
    end
  end

  # DELETE /artigos/1
  def destroy
    if @artigo.url_imagem.present?
      # extrai o public_id da url(Opção dois onde nao armazenamos o public_id da imagem no proprio artigo)
      public_id = @artigo.url_imagem.split("/")[-1].split(".")[0]
      Cloudinary::Uploader.destroy(public_id)
    end

    @artigo.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_artigo
      @artigo = Artigo.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def artigo_params
      params.require(:artigo).permit(:titulo, :conteudo, :local, :data, :autor_id, :status, tags: [])
    end
end
