class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :external_id
      t.string :account_id
      t.boolean :deleted, default: false
      t.boolean :archived, default: false

      t.timestamps
    end
    add_index :contacts, [:account_id]
  end
end
