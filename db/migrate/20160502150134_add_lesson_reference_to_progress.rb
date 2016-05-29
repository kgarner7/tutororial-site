class AddLessonReferenceToProgress < ActiveRecord::Migration
  def change
    add_reference :progresses, :lesson, index: true, foreign_key: true
  end
end
