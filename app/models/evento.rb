# belongs_to = pertence_a
# optional: true permite que isso seja falso
class Evento < ApplicationRecord
  belongs_to :autor, optional: true
  belongs_to :imagem, optional: true, foreign_key: 'imagen_id' #se eu deletar o evento a imagem morre
  
  accepts_nested_attributes_for :imagem, reject_if: :all_blank, allow_destroy: true

end