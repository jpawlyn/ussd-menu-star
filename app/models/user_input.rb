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

  def validate_input(input)
    return "No input given" if input.blank?

    error = validate_data_type(input)
    return error if error

    validate_input_length(input)
  end

  def validate_data_type(input)
    case data_type
    when "integer"
      !Integer(input, exception: false) ? "You must enter an integer" : nil
    when "number"
      !Float(input, exception: false) ? "You must enter a number" : nil
    end
  end

  def validate_input_length(input)
    if min_length && input.length < min_length
      "Input must be at least #{min_length} characters"
    elsif max_length && input.length > max_length
      "Input must be no more than #{max_length} characters"
    end
  end
end
