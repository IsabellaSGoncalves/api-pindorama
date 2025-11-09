class Imagem < ApplicationRecord
  has_one :artigo, dependent: :nullify #Se excluir o oobjeto definira a chave como nula
  has_one :evento, dependent: :nullify
end