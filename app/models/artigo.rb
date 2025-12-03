class Artigo < ApplicationRecord
  belongs_to :autor, optional: true
  belongs_to :imagem, optional: true, foreign_key: 'imagen_id'

  accepts_nested_attributes_for :imagem, reject_if: :all_blank, allow_destroy: true

  after_commit :gerar_coordenadas_se_necessario, on: [:create, :update]

  def gerar_coordenadas_se_necessario
    # Proteção 1: Garante que a coluna 'local' foi alterada (ou é um novo registro)
    return unless saved_change_to_local? || coordenadas.blank? 
    return unless local.present?

    # Proteção 2: Use um flag para evitar loops infinitos se o update_column disparar o callback
    return if @coordenadas_em_atualizacao
    @coordenadas_em_atualizacao = true # Define a flag

    coord = CoordenadaService.gerar(self.id)
    return unless coord.present?

    # update_column é a forma correta pois não dispara callbacks, mas a flag é uma camada extra
    update_column(:coordenadas, [coord[:lat].to_f, coord[:lon].to_f]) 

    @coordenadas_em_atualizacao = false # Limpa a flag
  end
end