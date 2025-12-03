class Imagem < ApplicationRecord
  # A imagem é referenciada (possivelmente) por um Artigo ou Evento
  # Não há necessidade de belongs_to ou has_one aqui
  # A destruição é tratada pelo Artigo/Evento (o belongs_to)
  # has_one :artigo, dependent: :nullify #Se excluir o oobjeto definira a chave como nula
  # has_one :evento, dependent: :nullify
end