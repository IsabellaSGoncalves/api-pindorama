class CreateEventos < ActiveRecord::Migration[8.0]
  def change
    create_table :eventos do |t|
      t.string :titulo, null: false
      t.text :conteudo, null: false
      t.text :tags, array: true, default: []
      t.string :url_imagem
      t.string :local, null: false
      t.column :data, :timestamptz, null: false

      t.references :autor, null: true, foreign_key: { on_delete: :nullify }
    end
  end
end
