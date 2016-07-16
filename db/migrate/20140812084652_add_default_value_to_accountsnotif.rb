class AddDefaultValueToAccountsnotif < ActiveRecord::Migration
  def up
    Account.update_all({:has_notif => false}, {:has_notif => nil})
	  change_column :accounts, :has_notif, :boolean, default: false, :null => false
	end

	def down
	  change_column :accounts, :has_notif, :boolean, default: nil, :null => true
	end
end
