class MenuItem < ApplicationRecord
  include SessionStore

  validate :account_consistency_check
  validate :menu_item_circularity_check
  validate :menu_item_user_inputs_do_not_exist
  validates :title, presence: true
  validates :menu_item, presence: true, if: :main_menu_item_exists?
  validates :menu_item, absence: true, if: :main_menu_item?

  normalizes :title, with: ->(name_attr) { name_attr.strip }
  normalizes :content, with: ->(name_attr) { name_attr.strip.presence }

  belongs_to :account
  belongs_to :menu_item, optional: true
  has_many :menu_items, -> { order(position: :asc) }, dependent: :restrict_with_error
  has_many :user_inputs, -> { order(position: :asc) }, dependent: :restrict_with_error

  acts_as_list scope: :menu_item

  # this is not very efficient since it retrieves the ids of ALL menu items
  # irrespective of whether they are needed. It would be better to pass in the root node
  # but that wouldn't play so nicely with the Avo has_many field
  scope :in_hierarchy_order, -> { in_order_of(:id, hierarchy.map(&:id)) }

  # recursive CTE to get the hierarchy of menu items in order of
  # depth and position
  # either from a specific menu item or from all root menu items
  def self.hierarchy(menu_item = nil)
    where_clause = menu_item ? { id: menu_item } : { menu_item: nil }
    with_recursive(descendants: [
      Arel.sql(select("menu_items.*", "0 as depth").where(where_clause).to_sql),
      Arel.sql(select("menu_items.*", "descendants.depth + 1 as depth")
        .joins("JOIN descendants ON menu_items.menu_item_id = descendants.id").to_sql)
    ]).select("*").from("descendants").order("depth ASC, position ASC")
  end

  def hierarchy
    self.class.hierarchy(self)
  end

  def menu_text
    no_user_inputs? ? menu_items_text : user_input_text
  end

  def select_menu_item(input)
    no_user_inputs? ? menu_items[input.to_i - 1] : store_input(input)
  end

  def no_user_inputs?
    user_inputs.empty?
  end

  def avo_name
    "#{title} (#{account.name})"
  end

  def self.ransackable_attributes(_auth_object = nil)
    column_names
  end

  private

  def menu_items_text
    text = fetch_content
    menu_items.each_with_index do |menu_item, i|
      text += "#{i + 1} #{menu_item.title}\n"
    end
    text.chop
  end

  def user_input_text
    next_user_input = fetch_next_user_input
    if next_user_input
      error_text = @error ? "#{@error}\n\n" : ""
      "#{error_text}#{next_user_input.content}"
    else
      "#{fetch_content}\n0 Back"
    end
  end

  def store_input(input)
    return self unless input.present?

    user_input = fetch_next_user_input
    @error = user_input&.validate_input(input)
    store_user_input(self, user_input, input) if user_input && @error.nil?
    self
  end

  def fetch_next_user_input
    stored_input_keys = fetch_user_input_keys(self)
    user_inputs.find { |user_input| stored_input_keys.exclude?(user_input.key) }
  end

  def fetch_content
    return "" unless content.present?

    menu_items.to_a.any? ? "#{content}\n\n" : "#{content}\n"
  end

  def account_consistency_check
    return if account.nil? || menu_item.nil?
    return if account == menu_item.account

    errors.add(:menu_item, "must belong to the same account")
  end

  def menu_item_circularity_check
    return if menu_item.nil?
    return if hierarchy.to_a.exclude?(menu_item)

    errors.add(:menu_item, "cannot reference itself or a submenu item")
  end

  def main_menu_item?
    MenuItem.find_by(id:, menu_item: nil)
  end

  def main_menu_item_exists?
    return false unless account

    MenuItem.where(account:, menu_item: nil).where.not(id:).any?
  end

  def menu_item_user_inputs_do_not_exist
    return unless menu_item&.user_inputs&.any?

    errors.add(:menu_item, "must not have any user inputs")
  end
end
