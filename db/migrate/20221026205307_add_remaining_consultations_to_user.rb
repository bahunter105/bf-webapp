class AddRemainingConsultationsToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :remaining_consultations, :integer, default: 0
  end
end
