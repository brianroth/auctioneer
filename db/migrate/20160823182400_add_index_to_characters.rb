class AddIndexToCharacters < ActiveRecord::Migration[5.0]
  def change
    add_index(:characters, [:realm_id, :name], unique: true)
  end
end
