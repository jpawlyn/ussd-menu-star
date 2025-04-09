class UserInput < ApplicationRecord
  validates :key, uniqueness: { scope: :menu_item_id }, presence: true
  validates :content, presence: true
  validates :min_length, numericality: { only_integer: true }, allow_nil: true
  validates :max_length, numericality: { only_integer: true }, allow_nil: true
  normalizes :key, with: ->(name_attr) { name_attr.downcase.squish.gsub(" ", "_") }
  normalizes :content, with: ->(name_attr) { name_attr.strip.presence }

  enum :data_type, { text: 0, integer: 1, number: 2 }

  belongs_to :menu_item

  acts_as_list scope: :menu_item
end
