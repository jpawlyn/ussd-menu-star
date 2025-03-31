class ServiceCode < ApplicationRecord
  validates :name, uniqueness: true, presence: true
  validates :country_code, length: { is: 3 }, presence: true
  validates :short_name, uniqueness: { scope: :country_code }, presence: true

  normalizes :name, :country_code, :short_name, with: ->(name_attr) { name_attr.strip }
  normalizes :short_name, with: ->(name_attr) { name_attr.downcase.strip.gsub(" ", "-") }

  has_many :accounts, dependent: :restrict_with_error
end
