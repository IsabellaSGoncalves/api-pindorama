class CreateArtigos < ActiveRecord::Migration[8.0]
  def change
    create_table :artigos do |t|
      t.string :titulo, null: false
      t.text :conteudo, null: false
      t.text :tags, array: true, default: []
      t.string :url_imagem
      t.string :local, null: false
      t.column :data, :timestamptz, default: -> { "TIMEZONE('America/Sao_Paulo', NOW())" }

      t.references :autor, null: true, foreign_key: { on_delete: :nullify }
    end
  end
end
