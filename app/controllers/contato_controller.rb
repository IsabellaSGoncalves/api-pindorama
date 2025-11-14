class ContatoController < ApplicationController
  def create
    email_params = params.require(:contato).permit(:nome, :email, :mensagem)
    if ContatoMailer.contato_email(email_params).deliver_now
      head :ok 
    else
      render json: { error: "Falha ao enviar e-mail" }, status: :unprocessable_entity 
    end
  rescue ActionController::ParameterMissing
    render json: { error: "Parâmetros ausentes" }, status: :bad_request
  end
end