class AddUniqueHashToAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :unique_hash, :string
    add_index :answers, :unique_hash, unique: true
  end
end