class MenuItem < ApplicationRecord
  validates :title, presence: true
  validates :menu_item, presence: true, if: :main_menu_exists?
  validates :menu_item, absence: true, if: :main_menu?

  normalizes :title, with: ->(name_attr) { name_attr.strip }
  normalizes :content, with: ->(name_attr) { name_attr.strip.presence }

  belongs_to :account
  belongs_to :menu_item, optional: true
  has_many :menu_items, dependent: :restrict_with_error

  def main_menu?
    MenuItem.find_by(id:, menu_item: nil)
  end

  def main_menu_exists?
    return false unless account

    MenuItem.where(account:, menu_item: nil).where.not(id:).any?
  end
end
