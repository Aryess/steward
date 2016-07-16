class AddJsonDumpToAccount < ActiveRecord::Migration
  def change
  	add_column :accounts, :jsondump, :string
  end
end
