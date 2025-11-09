class AddImagemIdToEventos < ActiveRecord::Migration[8.0]
  def change
    add_reference :eventos, :imagen, foreign_key: true
  end
end
