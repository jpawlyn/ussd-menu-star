class UserInput < ApplicationRecord
  validate :menu_items_do_not_exist_for_menu_item
  validates :key, uniqueness: { scope: :menu_item_id }, presence: true
  validates :content, presence: true
  validates :min_length, numericality: { only_integer: true }, allow_nil: true
  validates :max_length, numericality: { only_integer: true }, allow_nil: true
  normalizes :key, with: ->(name_attr) { name_attr.downcase.squish.gsub(" ", "_") }
  normalizes :content, with: ->(name_attr) { name_attr.strip.presence }

  enum :data_type, { text: 0, integer: 1, number: 2 }

  belongs_to :menu_item

  acts_as_list scope: :menu_item

  def validate_input(input)
    return [ "No input given" ] if input.blank?

    error, formatted_input = validate_data_type(input)
    return Array(error) if error

    [ validate_input_length(input), formatted_input ]
  end

  def validate_data_type(input)
    case data_type
    when "integer"
      formatted_input = Integer(input, exception: false)
      error = !formatted_input ? "You must enter an integer" : nil
    when "number"
      formatted_input = Float(input, exception: false)
      error = !formatted_input ? "You must enter a number" : nil
    when "text"
      formatted_input = input
      error = nil
    end
    [ error, formatted_input ]
  end

  def validate_input_length(input)
    if min_length && input.length < min_length
      "Input must be at least #{min_length} characters"
    elsif max_length && input.length > max_length
      "Input must be no more than #{max_length} characters"
    end
  end

  private

  def menu_items_do_not_exist_for_menu_item
    return unless menu_item&.menu_items&.any?

    errors.add(:menu_item, "must not have any sub menu items")
  end
end
