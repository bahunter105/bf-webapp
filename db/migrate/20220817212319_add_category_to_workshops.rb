class AddCategoryToWorkshops < ActiveRecord::Migration[6.1]
  def change
    add_column :workshops, :category, :string
  end
end
