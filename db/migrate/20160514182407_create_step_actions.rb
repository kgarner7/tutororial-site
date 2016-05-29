class CreateStepActions < ActiveRecord::Migration
  def change
    create_table :step_actions do |t|
      t.references :step, index: true, foreign_key: true
      t.string :index
      t.string :integer

      t.timestamps null: false
    end
  end
end
