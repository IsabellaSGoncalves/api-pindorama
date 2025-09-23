# Definindo as cardinalidades/relacionamentos entre tabelas
# dependent: :nullify se o autor for deletado, artigos ficam com autor_id = NULL
class Autor < ApplicationRecord
  has_many :artigos, dependent: :nullify
  has_many :eventos, dependent: :nullify

  attr_accessor :password

  before_save :encrypt_password

  def autenticar(password)
    BCrypt::Password.new(self.senha) == password
  end

  private

  def encrypt_password
    self.senha = BCrypt::Password.create(password)
  end
end
