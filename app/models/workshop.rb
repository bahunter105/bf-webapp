class Workshop < ApplicationRecord
  has_many :bookmarks, dependent: :destroy
  has_many :users, through: :bookmarks
  validates :category, inclusion: { in: %w(families educators), message: "%{value} is not a valid category" }
  monetize :price_cents
end
