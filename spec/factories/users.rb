FactoryBot.define do
  factory :user do
    sequence(:email_address) { |n| "one-#{n}@example.com" }
    password { "password" }
  end
end
