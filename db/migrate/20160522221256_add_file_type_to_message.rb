class AddFileTypeToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :file_type, :string
  end
end
