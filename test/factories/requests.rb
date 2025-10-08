FactoryBot.define do
  factory :request do
    association :team
    customer { nil }
  end
end
