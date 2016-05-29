class AddTempIndexToStepAction < ActiveRecord::Migration
  def change
    add_column :step_actions, :temp_index, :integer
  end
end
