class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :file_name
      t.references :student, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
