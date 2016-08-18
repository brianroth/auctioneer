class CreateGuilds < ActiveRecord::Migration[5.0]
  def change
    create_table :guilds do |t|
      t.string :name, null: false
      t.string :realm, null: false
      t.timestamps null: false
    end
  end
end
