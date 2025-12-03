# Ruby é ORM, logo aqui estão consultas SQL sem usar SQL, isso é possivel pelo Active Record

class ArtigosController < ApplicationController
  before_action :set_artigo, only: %i[ show update destroy ]

  # GET /artigos
  def index
    if params[:autor_id].present? #adicionando o parametro id_Autor /eventos?autor_id=7
      # EAGER LOADING ocupa mais memoria, aqui não é necessaria.
      @artigos = Artigo.where(autor_id: params[:autor_id]).includes(:imagem)
    else
      @artigos = Artigo.all.includes(:imagem)
    end
    render json: @artigos.as_json(
      include: { imagem: { only: [:url_imagem, :creditos, :descricao] } }
    ) 
  end

  # GET /artigos/1
  def show
    # EAGER LOADING aqui é necessario, pois na tela detalhes vemos a autora!
    # Inclui dados do autor na resposta JSON criando um array retorna autor: {id: X, nome: "Nome"}
    render json: @artigo.as_json(
      include: {
        autor: { only: [:id, :nome]},
        imagem: { only: [:url_imagem, :creditos, :descricao] }
      }
    )
    
  end

  # POST /artigos
  def create
    uploaded_image = params[:imagem]

    image_url = nil
    if uploaded_image.present? # Se uma imagem foi enviada
      # Dá upload na imagem e armazena os dados em result
      result = Cloudinary::Uploader.upload( uploaded_image, folder: "artigos", public_id: SecureRandom.uuid)
      
      image = Imagem.new(
        cloud_id: result["public_id"], # Agora armazenamos o public_id
        url_imagem: result["secure_url"],
        creditos: artigo_params[:creditos_imagem], # Usando os novos parametros
        descricao: artigo_params[:alt_imagem] # Usando os novos parametros
      )

      unless image.save
        return render json: { imagem_errors: image.errors }, status: :unprocessable_entity
      end
      
      # Pega a URL da imagem a partir do resultado do upload
      # image_url = result["secure_url"]
    end
    # Removendo os campos que não existem em artigos
    artigo_attrs = artigo_params.except(:creditos_imagem, :alt_imagem) 

    # Cria um novo artigo com os parametros
    @artigo = Artigo.new(artigo_attrs)
    @artigo.imagem = image if image.present? # Associa o objeto Imagem

    if @artigo.save
      render json: @artigo, status: :created, location: @artigo
    else
      # Se falhar, tentamos deletar a imagem que já foi enviada (limpeza)
      image.destroy if image.present? && image.persisted?
      render json: @artigo.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /artigos/1
  def update
    uploaded_image = params[:imagem]

    # Remove os campos de imagem do hash Artigo para o Artigo.update
    artigo_attrs = artigo_params.except(:creditos_imagem, :alt_imagem)
    
    image_to_destroy = nil
    image_to_create = nil

    if uploaded_image.present?
      # Se já existe imagem, remove a antiga
      if @artigo.imagem.present?
        image_to_destroy = @artigo.imagem
      end

      # Faz upload da nova imagem
      result = Cloudinary::Uploader.upload( uploaded_image, folder: "artigos", public_id: SecureRandom.uuid)
      image_to_create = Imagem.new(
        cloud_id: result["public_id"],
        url_imagem: result["secure_url"],
        creditos: artigo_params[:creditos_imagem],
        descricao: artigo_params[:alt_imagem]
      )

      unless image_to_create.save
        return render json: { imagem_errors: image_to_create.errors }, status: :unprocessable_entity
      end
      
      @artigo.imagem = image_to_create
      
    elsif artigo_params[:creditos_imagem].present? || artigo_params[:alt_imagem].present?
      # Se NÃO houve upload, mas os metadados foram alterados, atualiza a imagem existente
      if @artigo.imagem.present?
        @artigo.imagem.update(
          creditos: artigo_params[:creditos_imagem],
          descricao: artigo_params[:alt_imagem]
        )
      end
    end
      # Atualiza só os outros campos
    if @artigo.update(artigo_attrs)
      if image_to_destroy.present?
        Cloudinary::Uploader.destroy(image_to_destroy.cloud_id) # Usa o cloud_id
        image_to_destroy.destroy # Destrói no DB
      end
      render json: @artigo
    else
      # Se o artigo falhar, remove a nova imagem que foi criada
      image_to_create.destroy if image_to_create.present?
      render json: @artigo.errors, status: :unprocessable_entity
    end
  end

  # DELETE /artigos/1
  def destroy
    imagem_a_deletar = @artigo.imagem

    @artigo.destroy!

    if imagem_a_deletar.present?
      Cloudinary::Uploader.destroy(imagem_a_deletar.cloud_id)
      imagem_a_deletar.destroy! # Agora que o Artigo não a referencia mais, esta linha deve funcionar.
    end
    head :no_content
  end

  def update_coordenadas_interna
    @artigo = Artigo.find(params[:id])
    
    # Usar update_column bypassa callbacks e validações do Model
    if @artigo.update_column(:coordenadas, params[:coordenadas])
      head :no_content # Retorna status 204 (No Content)
    else
      # Não deve acontecer, mas é bom ter
      render json: { erro: 'Falha ao atualizar coluna de coordenadas' }, status: :unprocessable_entity
    end
  end

private
    # Use callbacks to share common setup or constraints between actions.
    def set_artigo
      # MUDANÇA AQUI: Adicionar .includes(:autor, :imagem)
      @artigo = Artigo.includes(:autor, :imagem).find(params[:id])
    end

      # Only allow a list of trusted parameters through.
    def artigo_params
      # Aceita coordenadas SE a action for a de atualização interna
      permitidos = [:titulo, :conteudo, :local, :data, :autor_id, :status, tags: []]
      permitidos << :coordenadas if action_name == 'update_coordenadas_interna'

      # 💥 MUDANÇA CRUCIAL: Adicionar os novos campos da imagem
      permitidos << :creditos_imagem 
      permitidos << :alt_imagem
      
      params.require(:artigo).permit(permitidos)
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
