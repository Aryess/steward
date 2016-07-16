class RenameExpiresAtToExpiresat < ActiveRecord::Migration
  def change
    rename_column :accounts, :expires_at, :expiresat
  end
end
