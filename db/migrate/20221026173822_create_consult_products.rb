class CreateConsultProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :consult_products do |t|
      t.references :order, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
