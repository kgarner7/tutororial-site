class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.references :step_action, index: true, foreign_key: true
      t.string :answer
      t.boolean :correct

      t.timestamps null: false
    end
  end
end
