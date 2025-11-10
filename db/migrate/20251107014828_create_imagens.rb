class CreateImagens < ActiveRecord::Migration[8.0]
  def change
    create_table :imagens do |t|
      t.integer :cloud_id, index: { unique: true, name: "unique_cloundId" }
      t.string :creditos
      t.string :descricao
      t.string :url_imagem, null: false
    end
  end
end
