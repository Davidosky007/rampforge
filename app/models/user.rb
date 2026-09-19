class User < ApplicationRecord
  has_secure_password

  has_many :wallets, dependent: :restrict_with_exception

  before_validation :assign_public_id, on: :create

  validates :email, presence: true
  validates :email, uniqueness: { case_sensitive: false }

  validates :role,
            presence: true,
            inclusion: { in: %w[customer operator admin] }

  validates :status,
            presence: true,
            inclusion: { in: %w[active disabled] }

  private

  def assign_public_id
    self.public_id ||= SecureRandom.uuid
  end
end
