class CreateSteps < ActiveRecord::Migration
  def change
    create_table :steps do |t|
      t.references :lesson, index: true, foreign_key: true
      t.integer :score

      t.timestamps null: false
    end
  end
end
