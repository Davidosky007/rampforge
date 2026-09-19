# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_09_19_123744) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "ledger_accounts", force: :cascade do |t|
    t.string "account_kind", null: false
    t.string "account_type", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.string "currency", null: false
    t.string "normal_side", null: false
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.bigint "wallet_id"
    t.index ["code"], name: "index_ledger_accounts_on_code", unique: true
    t.index ["wallet_id", "account_kind"], name: "index_ledger_accounts_wallet_kind_unique", unique: true, where: "(wallet_id IS NOT NULL)"
    t.index ["wallet_id"], name: "index_ledger_accounts_on_wallet_id"
    t.check_constraint "account_kind::text = ANY (ARRAY['wallet_available'::character varying, 'wallet_reserved'::character varying, 'wallet_pending'::character varying, 'provider_clearing'::character varying, 'provider_receivable'::character varying, 'fee_revenue'::character varying, 'conversion_bridge'::character varying]::text[])", name: "ledger_accounts_kind_check"
    t.check_constraint "account_type::text = ANY (ARRAY['asset'::character varying, 'liability'::character varying, 'revenue'::character varying]::text[])", name: "ledger_accounts_type_check"
    t.check_constraint "currency::text = ANY (ARRAY['NGN'::character varying, 'USDT'::character varying]::text[])", name: "ledger_accounts_currency_check"
    t.check_constraint "normal_side::text = ANY (ARRAY['debit'::character varying, 'credit'::character varying]::text[])", name: "ledger_accounts_normal_side_check"
    t.check_constraint "status::text = ANY (ARRAY['active'::character varying, 'disabled'::character varying]::text[])", name: "ledger_accounts_status_check"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.uuid "public_id", null: false
    t.string "role", default: "customer", null: false
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.index "lower((email)::text)", name: "index_users_on_lower_email", unique: true
    t.index ["public_id"], name: "index_users_on_public_id", unique: true
    t.check_constraint "role::text = ANY (ARRAY['customer'::character varying, 'operator'::character varying, 'admin'::character varying]::text[])", name: "users_role_check"
    t.check_constraint "status::text = ANY (ARRAY['active'::character varying, 'disabled'::character varying]::text[])", name: "users_status_check"
  end

  create_table "wallets", force: :cascade do |t|
    t.bigint "available_minor", default: 0, null: false
    t.datetime "created_at", null: false
    t.string "currency", null: false
    t.bigint "pending_minor", default: 0, null: false
    t.string "reference", null: false
    t.bigint "reserved_minor", default: 0, null: false
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["reference"], name: "index_wallets_on_reference", unique: true
    t.index ["user_id", "currency"], name: "index_wallets_on_user_id_and_currency", unique: true
    t.index ["user_id"], name: "index_wallets_on_user_id"
    t.check_constraint "available_minor >= 0", name: "wallets_available_non_negative"
    t.check_constraint "currency::text = ANY (ARRAY['NGN'::character varying, 'USDT'::character varying]::text[])", name: "wallets_currency_check"
    t.check_constraint "pending_minor >= 0", name: "wallets_pending_non_negative"
    t.check_constraint "reserved_minor >= 0", name: "wallets_reserved_non_negative"
    t.check_constraint "status::text = ANY (ARRAY['active'::character varying, 'frozen'::character varying]::text[])", name: "wallets_status_check"
  end

  add_foreign_key "ledger_accounts", "wallets", on_delete: :restrict
  add_foreign_key "wallets", "users", on_delete: :restrict
end
