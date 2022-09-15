class RenameMoodleidToMoodeId < ActiveRecord::Migration[6.1]
  def change
    rename_column :workshops, :moodleid, :moodle_id
  end
end
