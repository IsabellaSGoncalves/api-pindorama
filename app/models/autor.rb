# Definindo as cardinalidades/relacionamentos entre tabelas
# dependent: :nullify se o autor for deletado, artigos ficam com autor_id = NULL
class Autor < ApplicationRecord
  has_many :artigos, dependent: :nullify
  has_many :eventos, dependent: :nullify
end
