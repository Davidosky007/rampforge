FactoryBot.define do
  factory :wallet do
    association :user
    currency { "NGN" }
    status { "active" }

    available_minor { 0 }
    reserved_minor { 0 }
    pending_minor { 0 }
  end
end
