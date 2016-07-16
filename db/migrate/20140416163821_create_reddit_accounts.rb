class CreateRedditAccounts < ActiveRecord::Migration
  def change
    create_table :reddit_accounts do |t|
      t.string :login
      t.string :password
      t.integer :user_id

      t.timestamps
    end
    add_index :reddit_accounts, [:user_id, :login]
  end
end
