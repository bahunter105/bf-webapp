class ConsultProduct < ApplicationRecord
  belongs_to :order
  has_one :user, through: :orders
  monetize :price_cents
end
