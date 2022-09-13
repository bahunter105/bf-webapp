class RemoveWorkshopsFromOrders < ActiveRecord::Migration[6.1]
  def change
    remove_reference :orders, :workshop, index: true, foreign_key: true
  end
end
