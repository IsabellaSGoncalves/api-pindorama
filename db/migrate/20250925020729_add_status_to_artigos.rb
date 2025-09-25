class AddStatusToArtigos < ActiveRecord::Migration[8.0]
  def change
    add_column :artigos, :status, :string, null:false, default:'rascunho'
  end
end
