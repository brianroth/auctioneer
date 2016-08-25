class CreateAuctions < ActiveRecord::Migration[5.0]
  def change
    create_table :auctions do |t|
      t.references :item, null: false
      t.references :character, null: false
      t.references :realm, null: false
      t.integer :bid, null: false, :limit => 8 
      t.integer :buyout, null: false, :limit => 8 
      t.integer :quantity, null: false
      t.string :time_left, null: false
      t.timestamps null: false
    end
  end
end
