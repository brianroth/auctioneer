class CreateClazzs < ActiveRecord::Migration[5.0]
  def change
    create_table :clazzs do |t|
      t.string :name, null: false
      t.string :power_type, null: false
      t.integer :mask
      t.timestamps
    end
  end
end
