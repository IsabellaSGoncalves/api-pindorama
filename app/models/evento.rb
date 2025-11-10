# belongs_to = pertence_a
# optional: true permite que isso seja falso
class Evento < ApplicationRecord
  belongs_to :autor, optional: true
  belongs_to :imagem, optional: true, dependent: :destroy #se eu deletar o evento a imagem morre
end