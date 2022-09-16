class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.references :order, null: false, foreign_key: true
      t.references :workshop, null: false, foreign_key: true
      t.timestamps
    end
  end
end
