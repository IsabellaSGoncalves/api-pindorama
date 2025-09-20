module Login
module Api
    class AdministradoresController < ApplicationController
            def autenticar
              senha_do_usuario = params.require(:administrador).permit(:senha)[:senha]
              autor = Autor.first
              if autor && autor.autenticar(senha_do_usuario)
                session[:autor_id] = autor.id
                session[:autor_nome] = autor.nome
                render json: { message: "Login sucedido" }, status: :ok
              else
                render json: { error: "Senha incorreta" }, status: :unauthorized
              end
            end
    end
end
end
