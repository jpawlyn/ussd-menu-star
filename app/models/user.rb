class User < ApplicationRecord
  has_secure_password

  validates :email_address, uniqueness: true, presence: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  has_many :sessions, dependent: :destroy

  def self.ransackable_attributes(_auth_object = nil)
    [ :email_address ]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
