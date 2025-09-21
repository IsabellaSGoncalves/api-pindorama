class AddStatusToArtigosAndEventos < ActiveRecord::Migration[8.0]
  def change
    add_column :artigos, :status, :string, default: "rascunho", null: false
    add_column :eventos, :status, :string, default: "rascunho", null: false
  end
end
