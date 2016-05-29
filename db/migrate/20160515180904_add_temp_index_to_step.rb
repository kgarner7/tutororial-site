class AddTempIndexToStep < ActiveRecord::Migration
  def change
    add_column :steps, :temp_index, :integer
  end
end
