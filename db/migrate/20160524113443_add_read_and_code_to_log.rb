class AddReadAndCodeToLog < ActiveRecord::Migration
  def change
    add_column :logs, :read, :boolean
    add_column :logs, :previous_code, :string
    add_column :logs, :encrypted_previous_code, :string
  end
end
