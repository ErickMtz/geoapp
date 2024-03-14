FactoryBot.define do
  factory :geolocation do
    sequence(:ip) { |n| "8.8.8.#{n}" }
    country_code { "USA" }
  end
end
