FactoryBot.define do
  factory :event do
    title { FFaker::Lorem.phrase }
    description { FFaker::Lorem.paragraph }
    country { FFaker::Address.country }
    date { FFaker::Date.forward }
    lat { FFaker::Geolocation.lat }
    long { FFaker::Geolocation.lng }
  end
end
