class AddMonetizeToConsultProducts < ActiveRecord::Migration[6.1]
  def change
    add_monetize :consult_products, :price, currency: { present: false }
  end
end
