class AddSpecificsToStepAction < ActiveRecord::Migration
  def change
    add_column :step_actions, :value, :string
    add_column :step_actions, :type, :string
  end
end
