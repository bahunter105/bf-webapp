class AddMoodleIdToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :moodle_id, :integer
    add_column :users, :moodle_password, :string
  end
end
