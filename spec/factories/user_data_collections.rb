FactoryBot.define do
  factory :user_data_collection do
    msisdn { "254700000000" }
    data { { "blood_pressure" => 123, "heart_rate" => 72 } }
    menu_item
  end
end
