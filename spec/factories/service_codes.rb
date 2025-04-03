FactoryBot.define do
  factory :service_code do
    sequence(:name) { |n| "Test name #{n}" }
    country_code { "UGA" }
    short_name { name }
  end
end
