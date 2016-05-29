class Lesson < ActiveRecord::Base
  validates :name, presence: true
  has_many :steps, dependent: :destroy

  after_create {
    Dir.mkdir("app/views/lesson/#{self.id}")
    Dir.mkdir("app/assets/javascripts/#{self.id}")
    File.new "app/assets/stylesheets/#{self.id}/lesson.scss"
    File.open("app/assets/stylesheets/lessons.scss", "a") do
      file.puts "@import '#{self.id}/lesson';"
    end
  }  
  
  after_destroy {
    Dir.delete("app/views/lesson/#{self.id}")
    Dir.delete "app/assets/javascripts/#{self.id}"
    File.delete "app/assets/stylesheets/#{self.id}/lesson.scss"
    lesson_scss = File.read("app/assets/stylesheets/lessons.scss").gsub("@import '#{Lesson.last.id}/#{lesson}'",);
    File.open("app/assets/stylesheets/lessons.scss", "w") do
      file.puts lesson_scss
    end
  }
end