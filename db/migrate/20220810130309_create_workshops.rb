class CreateWorkshops < ActiveRecord::Migration[6.1]
  def change
    create_table :workshops do |t|
      t.string :fullname
      t.string :shortname
      t.text :summary
      t.string :language

      t.timestamps
    end
  end
end
