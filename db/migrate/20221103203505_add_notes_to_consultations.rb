class AddNotesToConsultations < ActiveRecord::Migration[6.1]
  def change
    add_column :consultations, :notes, :text
  end
end
