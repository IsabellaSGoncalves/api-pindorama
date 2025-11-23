class ChangeCoordenadasColumnType < ActiveRecord::Migration[8.0]
  def change
    # Remove a coluna antiga
    remove_column :artigos, :coordenadas

    # Cria novamente como array de floats
    add_column :artigos, :coordenadas, :float, array: true, default: []
  end
end
