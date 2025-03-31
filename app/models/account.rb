class Account < ApplicationRecord
  validates :name, uniqueness: { scope: :service_code_id }, presence: true
  normalizes :name, with: ->(name_attr) { name_attr.strip }

  belongs_to :service_code
  # using MenuItem.hierarchy_order.map(&:id) is not very efficient since it retrieves the ids of ALL menu items
  # and not just the menu items related to this account
  has_many :menu_items, -> { in_hierarchy_order }, dependent: :restrict_with_error

  def main_menu_item
    MenuItem.find_by(account: self, menu_item: nil)
  end
end
