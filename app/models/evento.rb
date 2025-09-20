# belongs_to = pertence_a
# optional: true permite que isso seja falso

class Evento < ApplicationRecord
  belongs_to :autor, optional: true
end
