class CreateBinds < ActiveRecord::Migration[5.0]
  def change
    create_table :binds do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
