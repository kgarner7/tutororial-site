class AddEncryptedUsernameToStudent < ActiveRecord::Migration
  def change
    add_column :students, :encrypted_username, :string
  end
end
