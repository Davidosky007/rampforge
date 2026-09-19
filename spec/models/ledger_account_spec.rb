require "rails_helper"

RSpec.describe LedgerAccount, type: :model do
  it "requires the account currency to match its wallet" do
    wallet = create(:wallet, currency: "NGN")

    account = described_class.new(
      wallet:,
      code: "test-account",
      currency: "USDT",
      account_type: "liability",
      account_kind: "wallet_available",
      normal_side: "credit"
    )

    expect(account).not_to be_valid

    expect(account.errors[:currency])
      .to include("must match the wallet currency")
  end
  it "enforces one wallet per currency per user in PostgreSQL" do
  user = create(:user)

  create(:wallet, user:, currency: "NGN")

  expect do
    Wallet.insert_all!(
      [
        {
          user_id: user.id,
          reference: "WLT_DUPLICATE",
          currency: "NGN",
          available_minor: 0,
          reserved_minor: 0,
          pending_minor: 0,
          status: "active",
          created_at: Time.current,
          updated_at: Time.current
        }
      ]
    )
  end.to raise_error(ActiveRecord::RecordNotUnique)
end
end
