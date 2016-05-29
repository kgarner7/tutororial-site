class AddUniqueHashToUserProgress < ActiveRecord::Migration
  def change
    add_column :user_progresses, :unique_hash, :string
    add_index :user_progresses, :unique_hash, unique: true
  end
end
