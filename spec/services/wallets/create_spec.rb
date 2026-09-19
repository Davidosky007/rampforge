require "rails_helper"

RSpec.describe Wallets::Create do
  describe ".call" do
    it "creates the wallet and its ledger accounts atomically" do
      user = create(:user)

      wallet = described_class.call(
        user:,
        currency: "NGN"
      )

      expect(wallet).to be_persisted
      expect(wallet.currency).to eq("NGN")

      expect(wallet.ledger_accounts.pluck(:account_kind))
        .to contain_exactly(
          "wallet_available",
          "wallet_reserved",
          "wallet_pending"
        )
    end

    it "does not persist a partially created wallet when account creation fails" do
  user = create(:user)

  expect do
    described_class.call(
      user:,
      currency: "INVALID"
    )
  end.to raise_error(ActiveRecord::RecordInvalid)

  expect(
    Wallet.where(user:).count
  ).to eq(0)
end

    it "creates liability accounts with credit normal balances" do
      user = create(:user)

      wallet = described_class.call(
        user:,
        currency: "NGN"
      )

      wallet.ledger_accounts.each do |account|
        expect(account.account_type).to eq("liability")
        expect(account.normal_side).to eq("credit")
      end
    end
  end
end
