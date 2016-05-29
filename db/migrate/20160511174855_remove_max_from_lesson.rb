class RemoveMaxFromLesson < ActiveRecord::Migration
  def change
    remove_column :lessons, :max, :integer
  end
end
