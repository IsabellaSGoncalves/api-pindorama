class ContatoMailer < ApplicationMailer
  DEFAULT_FROM = ENV["MAIL_FROM_ADDRESS"] || "test@example.com"
  DEFAULT_TO = 'isabelllacom2l@gmail.com' 

  def contato_email(params)
    @nome = params[:nome]
    @email_remetente = params[:email] 
    @mensagem = params[:mensagem]
    
    mail(
      to: DEFAULT_TO,
      from: DEFAULT_FROM, 
      reply_to: @email_remetente, 
      
      subject: "[Equipe Pindorama] - Nova Mensagem de Contato de #{@nome}"
    )
  end
end