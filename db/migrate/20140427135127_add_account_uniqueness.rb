class AddAccountUniqueness < ActiveRecord::Migration
  def change
    remove_index :accounts, [:user_id, :login]
    add_index :accounts, [:user_id, :login], unique: true
  end
end
