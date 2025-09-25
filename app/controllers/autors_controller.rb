class AutorsController < ApplicationController
  before_action :set_autor, only: %i[ show update destroy ]

  # GET /autors
  def index
    @autors = Autor.all

    render json: @autors
  end

  # GET /autors/1
  def show
    render json: @autor
  end

  # POST /autors
  def create
    @autor = Autor.new(autor_params)

    if @autor.save
      render json: @autor, status: :created, location: @autor
    else
      render json: @autor.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /autors/1
  def update
    if @autor.update(autor_params)
      render json: @autor
    else
      render json: @autor.errors, status: :unprocessable_entity
    end
  end

  # DELETE /autors/1
  def destroy
    @autor.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_autor
      @autor = Autor.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def autor_params
      params.expect(autor: [ :nome, :foto, :email, :senha, :status ])
    end
end
