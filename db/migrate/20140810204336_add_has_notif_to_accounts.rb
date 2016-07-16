class AddHasNotifToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :has_notif, :boolean
  end
end
