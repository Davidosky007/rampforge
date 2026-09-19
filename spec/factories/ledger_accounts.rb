FactoryBot.define do
  factory :ledger_account do
    wallet { nil }
    code { "MyString" }
    currency { "MyString" }
    account_type { "MyString" }
    account_kind { "MyString" }
    normal_side { "MyString" }
    status { "MyString" }
  end
end
