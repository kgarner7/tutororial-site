class AddTempScoreToStepAction < ActiveRecord::Migration
  def change
    add_column :step_actions, :temp_score, :integer
  end
end
