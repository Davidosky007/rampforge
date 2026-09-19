class LedgerAccount < ApplicationRecord
  ACCOUNT_TYPES = %w[asset liability revenue].freeze

  ACCOUNT_KINDS = %w[
    wallet_available
    wallet_reserved
    wallet_pending
    provider_clearing
    provider_receivable
    fee_revenue
    conversion_bridge
  ].freeze

  NORMAL_SIDES = %w[debit credit].freeze

  belongs_to :wallet, optional: true

  validates :code, presence: true, uniqueness: true

  validates :currency,
            presence: true,
            inclusion: { in: Wallet::SUPPORTED_CURRENCIES }

  validates :account_type,
            presence: true,
            inclusion: { in: ACCOUNT_TYPES }

  validates :account_kind,
            presence: true,
            inclusion: { in: ACCOUNT_KINDS }

  validates :normal_side,
            presence: true,
            inclusion: { in: NORMAL_SIDES }

  validates :status,
            presence: true,
            inclusion: { in: %w[active disabled] }

  validate :wallet_currency_matches_account_currency

  private

  def wallet_currency_matches_account_currency
    return unless wallet
    return if wallet.currency == currency

    errors.add(:currency, "must match the wallet currency")
  end
end
