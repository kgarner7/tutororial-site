class AddAnswerTypeToAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :answer_type, :string
  end
end
