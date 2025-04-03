FactoryBot.define do
  factory :menu_item, aliases: [ :main_menu_item ] do
    title { "Main Menu" }
    association :account
  end

  factory :sub_menu_item, parent: :menu_item do
    sequence(:title) { |n| "Menu Item #{n}" }
    menu_item { association :menu_item, account: }
  end
end
