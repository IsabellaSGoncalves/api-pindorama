class CreateAutors < ActiveRecord::Migration[8.0]
  def change
    create_table :autors do |t|
      t.string :nome, null: false
      t.string :foto
      t.string :email, null: false
      t.string :senha, null: false
    end
    add_index :autors, :email, unique: true
  end
end
