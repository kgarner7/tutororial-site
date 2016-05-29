class RemoveEncryptedUsernameFromStudent < ActiveRecord::Migration
  def change
    remove_column :students, :encrypted_username, :student
  end
end
