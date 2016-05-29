class AddStepsToLesson < ActiveRecord::Migration
  def change
    add_column :lessons, :max, :integer
  end
end
