class CreateUserProgresses < ActiveRecord::Migration
  def change
    create_table :user_progresses do |t|
      t.references :step, index: true, foreign_key: true
      t.references :student, index: true, foreign_key: true
      t.integer :score
      t.references :lesson, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
