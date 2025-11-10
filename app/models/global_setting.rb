class GlobalSetting < ApplicationRecord # Diz que a classe representa a tabela global_settings do bd
  validates :chave, :valor, presence: true # Valida que chave e valor ao serem create estajam ambos true
end