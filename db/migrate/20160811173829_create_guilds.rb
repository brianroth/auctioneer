class CreateGuilds < ActiveRecord::Migration[5.0]
  def change
    create_table :guilds do |t|
      t.string :name, null: false
      t.references :realm, null: false
      t.integer :characters_count
      t.timestamps null: false
    end
  end
end
