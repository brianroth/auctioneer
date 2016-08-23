class AddIndexToCharacters < ActiveRecord::Migration[5.0]
  def change
    add_index(:characters, [:name, :realm], unique: true)
  end
end
