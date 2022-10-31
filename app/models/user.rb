class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :bookmarks, dependent: :destroy
  has_many :workshops, through: :bookmarks
  has_many :orders
  has_many :products, through: :orders
  has_many :consultations
  has_many :consult_products, through: :orders
  validates :first_name, :last_name, presence: true

  after_create :send_welcome_email

  private

  def send_welcome_email
    UserMailer.with(user: self).welcome.deliver_now!
  end
end
