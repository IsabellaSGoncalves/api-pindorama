class CreateGlobalSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :global_settings do |t|
      t.string :chave, null: false
      t.string :valor, null: false
    end
  end
end
