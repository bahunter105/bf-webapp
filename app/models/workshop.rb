class Workshop < ApplicationRecord
  validates :category, inclusion: { in: %w(families educators),
    message: "%{value} is not a valid category" }
end
