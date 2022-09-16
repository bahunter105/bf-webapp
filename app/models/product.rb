class Product < ApplicationRecord
  belongs_to :order
  belongs_to :workshop
  monetize :price_cents
end
