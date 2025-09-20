#belongs_to = pertence_a
#optional: true permite que isso seja falso

class Artigo < ApplicationRecord
  belongs_to :autor, optional:true
end
