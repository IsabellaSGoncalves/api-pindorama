class AddCoordenadasEImagemIdToArtigos < ActiveRecord::Migration[8.0]
  def change
    add_column :artigos, :coordenadas, :string
    add_reference :artigos, :imagen, foreign_key: true 
    # não necessario escrever imagem_id pois o como indicamos ser uma fk, ele ira adicionar esse id automaticamente
  end
end
