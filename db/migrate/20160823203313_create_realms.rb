class CreateRealms < ActiveRecord::Migration[5.0]
  def change
    create_table :realms do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :realm_type, null: false
      t.string :population, null: false
      t.string :battlegroup, null: false
      t.string :locale, null: false
      t.string :timezone, null: false
      t.timestamps
    end
  end
end
