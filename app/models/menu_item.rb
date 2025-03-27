class MenuItem < ApplicationRecord
  validates :title, presence: true
  validates :menu_item, presence: true, if: :main_menu_item_exists?
  validates :menu_item, absence: true, if: :main_menu_item?

  normalizes :title, with: ->(name_attr) { name_attr.strip }
  normalizes :content, with: ->(name_attr) { name_attr.strip.presence }

  belongs_to :account
  belongs_to :menu_item, optional: true
  has_many :menu_items, dependent: :restrict_with_error

  def menu_text
    text = fetch_content
    menu_items.each_with_index do |menu_item, i|
      text += "#{i + 1} #{menu_item.title}\n"
    end
    text.chop
  end

  def select_menu_item(user_input)
    menu_items[user_input.to_i - 1]
  end

  private

  def fetch_content
    return "" unless content.present?

    menu_items.to_a.any? ? "#{content}\n\n" : "#{content}\n"
  end

  def main_menu_item?
    MenuItem.find_by(id:, menu_item: nil)
  end

  def main_menu_item_exists?
    return false unless account

    MenuItem.where(account:, menu_item: nil).where.not(id:).any?
  end
end
