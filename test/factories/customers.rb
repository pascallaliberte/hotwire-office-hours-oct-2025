FactoryBot.define do
  factory :customer do
    association :team
    name { "MyString" }
  end
end
