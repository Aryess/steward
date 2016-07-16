class RenameRefreshToken < ActiveRecord::Migration
  def change
    rename_column :accounts, :refresh_token, :aux_token
  end
end
