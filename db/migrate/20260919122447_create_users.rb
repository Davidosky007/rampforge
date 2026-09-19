class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.uuid :public_id, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :role, null: false, default: "customer"
      t.string :status, null: false, default: "active"

      t.timestamps
    end

    add_index :users, :public_id, unique: true
    add_index :users, "LOWER(email)", unique: true, name: "index_users_on_lower_email"

    add_check_constraint :users,
                         "role IN ('customer', 'operator', 'admin')",
                         name: "users_role_check"

    add_check_constraint :users,
                         "status IN ('active', 'disabled')",
                         name: "users_status_check"
  end
end
