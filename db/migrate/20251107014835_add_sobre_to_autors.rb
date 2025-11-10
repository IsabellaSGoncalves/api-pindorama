class AddSobreToAutors < ActiveRecord::Migration[8.0]
  def change
    add_column :autors, :sobre, :string
  end
end
