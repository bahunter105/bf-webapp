class Workshop < ApplicationRecord
  has_many :bookmarks, dependent: :destroy
  has_many :users, through: :bookmarks
  has_many :orders, through: :products
  validates :category, inclusion: { in: %w(families educators), message: "%{value} is not a valid category" }
  monetize :price_cents
end
