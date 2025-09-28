class ArtigosController < ApplicationController
  before_action :set_artigo, only: %i[ show update destroy ]

  # GET /artigos
  def index
    if params[:autor_id].present?
      @artigos = Artigo.where(autor_id: params[:autor_id])
    else
      @artigos = Artigo.all
    end
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
      result = Cloudinary::Uploader.upload( uploaded_image, folder: "artigos", public_id: SecureRandom.uuid)
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
    uploaded_image = params[:imagem]

    if uploaded_image.present?
      # Se já existe imagem, remove a antiga
      if @artigo.url_imagem.present?
        public_id = extract_public_id(@artigo.url_imagem)
        Cloudinary::Uploader.destroy(public_id)
      end

      # Faz upload da nova imagem
      result = Cloudinary::Uploader.upload( uploaded_image, folder: "artigos", public_id: SecureRandom.uuid)
      image_url = result["secure_url"]

      # Atualiza com a nova URL
      if @artigo.update(artigo_params.merge(url_imagem: image_url))
        render json: @artigo
      else
        render json: @artigo.errors, status: :unprocessable_entity
      end
    else
      # Atualiza só os outros campos
      if @artigo.update(artigo_params)
        render json: @artigo
      else
        render json: @artigo.errors, status: :unprocessable_entity
      end
    end
  end

  # DELETE /artigos/1
  def destroy
    if @artigo.url_imagem.present?
      # extrai o public_id da url(Opção dois onde nao armazenamos o public_id da imagem no proprio artigo)
      public_id = extract_public_id(@artigo.url_imagem)
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

    # Método para extrair public_id de qualquer URL do Cloudinary
    def extract_public_id(url)
      # Pega tudo depois de "upload/" e remove versão (ex: v123456)
      parts = url.split("/upload/").last.split("/")
      parts.shift if parts.first.start_with?("v") # remove o "v12345"
      public_id_with_ext = parts.join("/")        # artigos/uuid.png
      public_id = public_id_with_ext.sub(File.extname(public_id_with_ext), "") # remove extensão
      public_id
    end
end
