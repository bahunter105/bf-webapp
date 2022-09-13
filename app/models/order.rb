class Order < ApplicationRecord
  belongs_to :user
  has_many :products
  has_many :workshops, through: :products
  monetize :amount_cents
end
