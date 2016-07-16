class RenameRedditAccountToAccount < ActiveRecord::Migration
  def change
    rename_table :reddit_accounts, :accounts
  end
end
