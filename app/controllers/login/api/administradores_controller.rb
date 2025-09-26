module Login
  module Api
    class AdministradoresController < ApplicationController
      before_action :authenticate_request, only: [:sessao]

      def autenticar
        senha_do_usuario = params.require(:administrador).permit(:senha)[:senha]
        autor = Autor.first

        if autor && autor.autenticar(senha_do_usuario)
          token = JsonWebToken.encode(autor_id: autor.id, autor_nome: autor.nome)
          render json: { token: token, message: "Login sucedido" }, status: :ok
        else
          render json: { error: "Senha incorreta" }, status: :unauthorized
        end
      end

      def sessao
        render json: {
          autor_id: @current_autor.id,
          autor_nome: @current_autor.nome
        }, status: :ok
      end

      private

      def authenticate_request
        token = request.headers["Authorization"]&.split(' ')&.last

        unless token
          render json: { error: "Token não fornecido" }, status: :unauthorized
          return
        end

        decoded = JsonWebToken.decode(token)

        unless decoded
          render json: { error: "Token inválido ou expirado" }, status: :unauthorized
          return
        end

        @current_autor = Autor.find_by(id: decoded[:autor_id])

        unless @current_autor
          render json: { error: "Autor não encontrado" }, status: :unauthorized
        end
      end
    end
  end
end
