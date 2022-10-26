class Consultation < ApplicationRecord
  belongs_to :order
  has_one :user, through: :orders
end
