FactoryBot.define do
  factory :requests_status, class: 'Requests::Status' do
    association :team
    name { "MyString" }
    slug { "MyString" }
    color { "MyString" }
  end
end
