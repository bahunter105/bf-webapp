class AddMoodleidToWorkshops < ActiveRecord::Migration[6.1]
  def change
    add_column :workshops, :moodleid, :integer
  end
end
