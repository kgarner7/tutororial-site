class ChangeIndexToInteger < ActiveRecord::Migration
  def change
    remove_column :step_actions, :index, :string
    add_column :step_actions, :index, :integer
  end
end
