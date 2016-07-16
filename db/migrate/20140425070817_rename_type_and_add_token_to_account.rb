class RenameTypeAndAddTokenToAccount < ActiveRecord::Migration
  def change
    rename_column :accounts, :type, :provider
    add_column :accounts, :token, :string
  end
end
