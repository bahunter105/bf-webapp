class Order < ApplicationRecord
  belongs_to :user
  has_many :products
  has_many :workshops, through: :products
  has_many :consult_products
  monetize :amount_cents
end
