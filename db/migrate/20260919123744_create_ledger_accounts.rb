class CreateLedgerAccounts < ActiveRecord::Migration[8.1]
  def change
    create_table :ledger_accounts do |t|
      t.references :wallet,
                   null: true,
                   foreign_key: { on_delete: :restrict }

      t.string :code, null: false
      t.string :currency, null: false
      t.string :account_type, null: false
      t.string :account_kind, null: false
      t.string :normal_side, null: false
      t.string :status, null: false, default: "active"

      t.timestamps
    end

    add_index :ledger_accounts, :code, unique: true

    add_index :ledger_accounts,
              [:wallet_id, :account_kind],
              unique: true,
              where: "wallet_id IS NOT NULL",
              name: "index_ledger_accounts_wallet_kind_unique"

    add_check_constraint :ledger_accounts,
                         "currency IN ('NGN', 'USDT')",
                         name: "ledger_accounts_currency_check"

    add_check_constraint :ledger_accounts,
                         "account_type IN ('asset', 'liability', 'revenue')",
                         name: "ledger_accounts_type_check"

    add_check_constraint :ledger_accounts,
                         "account_kind IN (
                           'wallet_available',
                           'wallet_reserved',
                           'wallet_pending',
                           'provider_clearing',
                           'provider_receivable',
                           'fee_revenue',
                           'conversion_bridge'
                         )",
                         name: "ledger_accounts_kind_check"

    add_check_constraint :ledger_accounts,
                         "normal_side IN ('debit', 'credit')",
                         name: "ledger_accounts_normal_side_check"

    add_check_constraint :ledger_accounts,
                         "status IN ('active', 'disabled')",
                         name: "ledger_accounts_status_check"
  end
end
