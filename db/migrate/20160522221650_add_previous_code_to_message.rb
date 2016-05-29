class AddPreviousCodeToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :previous_code, :string
  end
end
