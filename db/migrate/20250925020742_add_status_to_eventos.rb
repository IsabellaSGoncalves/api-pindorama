class AddStatusToEventos < ActiveRecord::Migration[8.0]
  def change
    add_column :eventos, :status, :string, null:false, default: 'rascunho'
  end
end
