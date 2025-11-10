class GlobalSettingsController < ApplicationController
  before_action :set_global_setting, only: [:show, :update, :destroy]

  # GET /global_settings
  def index
    @settings = GlobalSetting.all
    render json: @settings
  end

  # GET /global_settings/:id
  def show
    render json: @setting
  end

  # POST /global_settings
  def create
    @setting = GlobalSetting.new(global_setting_params)
    if @setting.save
      render json: @setting, status: :created
    else
      render json: @setting.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /global_settings/:id
  def update
    if @setting.update(global_setting_params)
      render json: @setting
    else
      render json: @setting.errors, status: :unprocessable_entity
    end
  end

  # DELETE /global_settings/:id
  def destroy
    @setting.destroy
    head :no_content
  end

  private

  def set_global_setting
    @setting = GlobalSetting.find(params[:id])
  end

  def global_setting_params
    params.require(:global_setting).permit(:chave, :valor)
  end
end
