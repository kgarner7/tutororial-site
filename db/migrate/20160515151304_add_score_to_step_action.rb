class AddScoreToStepAction < ActiveRecord::Migration
  def change
    add_column :step_actions, :score, :integer
  end
end
