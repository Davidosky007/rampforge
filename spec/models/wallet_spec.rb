require "rails_helper"

RSpec.describe Wallet, type: :model do
  describe "validations" do
    it "does not allow negative available balances" do
      wallet = build(:wallet, available_minor: -1)

      expect(wallet).not_to be_valid
    end

    it "does not allow negative reserved balances" do
      wallet = build(:wallet, reserved_minor: -1)

      expect(wallet).not_to be_valid
    end

    it "does not allow negative pending balances" do
      wallet = build(:wallet, pending_minor: -1)

      expect(wallet).not_to be_valid
    end

    it "allows one wallet per currency per user" do
      user = create(:user)

      create(:wallet, user:, currency: "NGN")

      duplicate = build(:wallet, user:, currency: "NGN")

      expect(duplicate).not_to be_valid
    end
  end

  describe "reference" do
    it "generates a wallet reference" do
      wallet = create(:wallet)

      expect(wallet.reference).to start_with("WLT_")
    end
  end

  describe "database constraints" do
  it "rejects a negative available balance at the database level" do
    wallet = create(:wallet)

    expect do
      Wallet.where(id: wallet.id)
            .update_all(available_minor: -1)
    end.to raise_error(ActiveRecord::StatementInvalid)
  end
end
end
