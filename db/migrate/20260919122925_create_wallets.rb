class CreateWallets < ActiveRecord::Migration[8.1]
  def change
    create_table :wallets do |t|
      t.references :user,
                   null: false,
                   foreign_key: { on_delete: :restrict }

      t.string :reference, null: false
      t.string :currency, null: false

      t.bigint :available_minor, null: false, default: 0
      t.bigint :reserved_minor, null: false, default: 0
      t.bigint :pending_minor, null: false, default: 0

      t.string :status, null: false, default: "active"

      t.timestamps
    end

    add_index :wallets, :reference, unique: true
    add_index :wallets, [:user_id, :currency], unique: true

    add_check_constraint :wallets,
                         "available_minor >= 0",
                         name: "wallets_available_non_negative"

    add_check_constraint :wallets,
                         "reserved_minor >= 0",
                         name: "wallets_reserved_non_negative"

    add_check_constraint :wallets,
                         "pending_minor >= 0",
                         name: "wallets_pending_non_negative"

    add_check_constraint :wallets,
                         "currency IN ('NGN', 'USDT')",
                         name: "wallets_currency_check"

    add_check_constraint :wallets,
                         "status IN ('active', 'frozen')",
                         name: "wallets_status_check"
  end
end
