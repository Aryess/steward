class AddExpiresAtToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :expires_at, :timestamp
  end
end
