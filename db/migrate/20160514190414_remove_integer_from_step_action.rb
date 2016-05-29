class RemoveIntegerFromStepAction < ActiveRecord::Migration
  def change
    remove_column :step_actions, :integer, :string
  end
end
