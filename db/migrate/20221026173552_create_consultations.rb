class CreateConsultations < ActiveRecord::Migration[6.1]
  def change
    create_table :consultations do |t|
      t.string :consult_category
      t.datetime :date_time
      t.boolean :completed
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
