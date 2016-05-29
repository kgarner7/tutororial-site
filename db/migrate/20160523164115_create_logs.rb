class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :file_name
      t.string :error

      t.timestamps null: false
    end
  end
end
