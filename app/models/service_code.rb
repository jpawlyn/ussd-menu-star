class ServiceCode < ApplicationRecord
  validates :name, uniqueness: true, presence: true
  validates :country_code, length: { is: 3 }, presence: true
  validates :short_name, uniqueness: true, presence: true

  normalizes :name, :country_code, :short_name, with: ->(name_attr) { name_attr.strip }

  has_many :accounts, dependent: :restrict_with_error
end
