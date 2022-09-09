class Order < ApplicationRecord
  belongs_to :user
  belongs_to :workshop
  monetize :amount_cents
end
