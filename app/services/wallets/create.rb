module Wallets
  class Create
    ACCOUNT_KINDS = {
      "wallet_available" => "credit",
      "wallet_reserved" => "credit",
      "wallet_pending" => "credit"
    }.freeze

    def self.call(user:, currency:)
      new(user:, currency:).call
    end

    def initialize(user:, currency:)
      @user = user
      @currency = currency
    end

    def call
      Wallet.transaction do
        wallet = Wallet.create!(
          user:,
          currency:
        )

        ACCOUNT_KINDS.each do |kind, normal_side|
          LedgerAccount.create!(
            wallet:,
            code: "#{wallet.reference}:#{kind}",
            currency: wallet.currency,
            account_type: "liability",
            account_kind: kind,
            normal_side:,
            status: "active"
          )
        end

        wallet
      end
    end

    private

    attr_reader :user, :currency
  end
end
