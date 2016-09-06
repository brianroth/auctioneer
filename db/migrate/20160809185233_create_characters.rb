class CreateCharacters < ActiveRecord::Migration[5.0]
  def change
    create_table :characters do |t|
      t.references :guild, null: true
      t.references :clazz, null: true
      t.references :race, null: true
      t.references :realm, null: false
      t.references :faction, null: true
      t.string :name, null: false
      t.integer :gender
      t.integer :level
      t.integer :achievement_points
      t.timestamps null: false
    end
  end
end
