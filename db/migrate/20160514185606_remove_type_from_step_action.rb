class RemoveTypeFromStepAction < ActiveRecord::Migration
  def change
    remove_column :step_actions, :type, :string
    add_column :step_actions, :action_type, :string
  end
end
