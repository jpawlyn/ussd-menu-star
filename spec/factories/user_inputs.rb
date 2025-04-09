FactoryBot.define do
  factory :user_input do
    sequence(:key) { |n| "key_#{n}" }
    data_type { "text" }
    content { "Please give your current blood pressure reading:" }
    menu_item
  end
end
