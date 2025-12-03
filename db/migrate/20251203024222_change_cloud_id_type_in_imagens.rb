class ChangeCloudIdTypeInImagens < ActiveRecord::Migration[8.0]
  def change
    # Altera o tipo da coluna para string/varchar
    change_column :imagens, :cloud_id, :string 

    # Opcional: Remova o índice UNIQUE temporariamente se houver dados '0'
    # remove_index :imagens, name: "unique_cloundId"
    # Adicione novamente após limpar dados ruins ou se for o primeiro
    # add_index :imagens, :cloud_id, unique: true
  end
end
