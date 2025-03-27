class Account < ApplicationRecord
  validates :name, uniqueness: { scope: :service_code_id }, presence: true
  normalizes :name, with: ->(name_attr) { name_attr.strip }

  belongs_to :service_code
  has_many :menu_items, dependent: :restrict_with_error

  def main_menu_item
    menu_items.find_by(menu_item: nil)
  end
end
