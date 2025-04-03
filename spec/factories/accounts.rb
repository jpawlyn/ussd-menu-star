FactoryBot.define do
  factory :account do
    name { "Test account" }
    association :service_code
  end
end
