class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.string :description
      t.string :icon
      t.references :bind, null: false
      t.integer :item_level, null: false
      t.integer :quality
      t.integer :item_clazz
      t.integer :item_sub_clazz
      t.integer :buy_price
      t.integer :sell_price
      t.timestamps null: false
    end
  end
end
