FactoryBot.define do
  factory :country do
    iso { FFaker::Address.country_code }
    name { FFaker::Address.country }
  end
end
