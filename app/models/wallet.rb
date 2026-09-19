class Wallet < ApplicationRecord
  SUPPORTED_CURRENCIES = %w[NGN USDT].freeze
  STATUSES = %w[active frozen].freeze

  belongs_to :user

  has_many :ledger_accounts, dependent: :restrict_with_exception

  before_validation :assign_reference, on: :create

  validates :reference, presence: true, uniqueness: true

  validates :currency,
            presence: true,
            inclusion: { in: SUPPORTED_CURRENCIES },
            uniqueness: { scope: :user_id }

  validates :status,
            presence: true,
            inclusion: { in: STATUSES }

  validates :available_minor,
            :reserved_minor,
            :pending_minor,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            }

  private

  def assign_reference
    self.reference ||= "WLT_#{SecureRandom.hex(10).upcase}"
  end
end
