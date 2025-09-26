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
    render json: @evento.as_json(except: [:created_at, :updated_at])
  end

  # POST /eventos
  def create
    uploaded_image = params[:evento][:imagem_capa]
    image_url = nil

    if uploaded_image.present?
      result = Cloudinary::Uploader.upload(uploaded_image)
      image_url = result["secure_url"]
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
      result = Cloudinary::Uploader.upload(uploaded_image)
      image_url = result["secure_url"]
    end

    update_params = evento_params
    
    # Se uma nova imagem foi enviada, adiciona a url_imagem aos parâmetros de atualização.
    update_params = update_params.merge(url_imagem: image_url) if image_url.present?

    if @evento.update(update_params)
      render json: @evento.as_json(except: [:created_at, :updated_at])
    else
      render json: @evento.errors, status: :unprocessable_entity
    end
  end

  # DELETE /eventos/1
  def destroy
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
        :data, 
        :local, 
        :autor_id, 
        tags: []
      )
    end
end