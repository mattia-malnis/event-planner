FactoryBot.define do
  factory :event do
    title { FFaker::Lorem.phrase }
    description { FFaker::Lorem.paragraph }
    date_start { FFaker::Date.backward }
    date_end { FFaker::Date.forward }
    lat { FFaker::Geolocation.lat }
    long { FFaker::Geolocation.lng }
    city { FFaker::Address.city }
    country
  end
end
