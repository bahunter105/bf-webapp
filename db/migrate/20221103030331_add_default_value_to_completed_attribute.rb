class AddDefaultValueToCompletedAttribute < ActiveRecord::Migration[6.1]
  def change
      change_column_default :consultations, :completed, from: nil, to: false
      add_column :consultations, :gcal_event_id, :string
  end
end
