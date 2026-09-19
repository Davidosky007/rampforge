FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "StrongPassword123!" }
    role { "customer" }
    status { "active" }
  end
end
