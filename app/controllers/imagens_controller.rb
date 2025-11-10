class ImagensController < ApplicationController
  before_action :set_imagem, only: [:show, :update, :destroy]

  # GET /imagens
  def index
    @imagens = Imagem.all
    render json: @imagens
  end

  # GET /imagens/:id
  def show
    render json: @imagem
  end

  # POST /imagens
  def create
    @imagem = Imagem.new(imagem_params)
    if @imagem.save
      render json: @imagem, status: :created
    else
      render json: @imagem.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /imagens/:id
  def update
    if @imagem.update(imagem_params)
      render json: @imagem
    else
      render json: @imagem.errors, status: :unprocessable_entity
    end
  end

  # DELETE /imagens/:id
  def destroy
    @imagem.destroy
  end

  private

  def set_imagem
    @imagem = Imagem.find(params[:id])
  end

  def imagem_params
    params.require(:imagem).permit(:clound_id, :creditos, :descricao, :url_imagem)
  end

end
