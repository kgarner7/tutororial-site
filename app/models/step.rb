class Step < ActiveRecord::Base
  has_many :user_progresses, dependent: :destroy
  has_many :step_actions, dependent: :destroy
  belongs_to :lesson  
  validates :name, presence: true
  default_scope -> { order(index: :asc) }
  action = ""
  

  before_create {
    action = "create"
    self.score = 0
    self.temp_index = 0
    last = Step.where(lesson: self.lesson).last()
    if self.index
      unless last
        self.index = 1
      else 
        if self.index > last.index + 1
          self.index = last.index + 1
        elsif self.index == last.index + 1
          self.temp_index = self.index
        else
          self.temp_index = self.index
          Step.find_by(lesson: self.lesson, index: self.index).update_attribute(:index, self.index + 1)
        end
      end
    else
      unless last
        self.index = 1
      else
        self.index = last.index + 1
      end
    end
    self.temp_index = self.index
  }
  
  before_update { 
    unless self.index == self.temp_index
      new_index = self.index
      self.index = self.temp_index   
  
      
      if action == "create"
        update_indices(self.temp_index < new_index, 1, self.temp_index + 1)
        process_file(self.temp_index, new_index)
        update_indices(self.temp_index > new_index, -1, self.temp_index + 1)
        self.index = self.temp_index += 1
      elsif action == "update"
        process_file(self.temp_index, new_index)
        action = ""
        self.index = self.temp_index = new_index
      else
        process_file(self.temp_index, "#{new_index}temporary")
        action = "update"
        Step.find_by(lesson: self.lesson, index: new_index).update_attribute(:index, self.temp_index)
        process_file("#{new_index}temporary", new_index)
        self.index = self.temp_index = new_index
      end
    end
  }
  
  after_create {
    File.open(path_to("html", self.id), "a+") do |html_file|
      html_file.puts("<div id=\"step-#{self.id}\">\n    <h2 class=\"text-center\"><%=Step.find_by(lesson: @lesson, id: @target).name%></h2>\n    <h3 id=\"step-error\" class=\"text-center errors-content\"></h3>\n")
    end
    File.open(path_to("coffee", self.id), "w+") {|js_file| 
      js_file.puts("$ -> \n  try\n    if $(\"\#step-#{self.id}\").length > 0\n      $(document).ajaxError () ->\n        error = 'an error occured in the file'\n        $.post('/lessons?type=ajax&id=#{self.id}&error=' + error)\n#content\n\n#content\n      document.passed='OK'\n  catch e\n    document.passed='error'\n    array = e.stack.split('\\n')[1].split(':')\n    line_num = parseInt(array[array.length - 2]) - 7\n    message = e.message + ' at line ' + line_num\n    $.post('/lessons?type=coffee&id=#{self.id}&error=' + message)")
      }
    Student.all.each {|student| student.user_progresses.create({step: self, lesson: self.lesson, score: 0})}
    File.open("app/assets/stylesheets/lessons.scss", "a") {|file| file.write("\n@import '#{self.lesson.id}/step_#{self.id}';")}
    File.open(path_to("scss", self.id), "w") {|file| file.puts("\n\#step-#{self.id} {\n\n}")}
    File.open(path_to("ajax", self.id), "w") {|file| file.puts("if(<%= @count == @max_score %>){\n    window.location = $(\".bottom-next\").attr(\"href\")\n}\nelse if(<%= @count >= @max_score / 2.0%>){\n}\nelse{\n}\n") }
    ["html", "scss", "ajax", "coffee"].each {|file_type| Message.create(file_name: path_to(file_type, self.id), file_type: file_type, previous_code: File.read(path_to(file_type, self.id)))}
    action = ""
  }
  
  # before_destroy {    
    # lesson_path = "app/assets/stylesheets/lessons.scss"
    # lesson_lines = File.read(lesson_path).gsub("@import '#{self.lesson.id}/step_#{self.id}';", "")
    # File.delete lesson_path
    # File.open(lesson_path, "w+") {|file| file.puts lesson_lines}
#     
    # step = Step.find_by(lesson: self.lesson, index: self.index + 1)
    # if step
      # step.update_attribute(:index, self.index)
    # end
    # ["html", "scss", "ajax", "coffee"].each do |file_type| 
      # file_path = path_to file_type, self.id
      # File.delete(file_path)
      # Message.where(file_name: file_path).find_each {|message| message.destroy}
    # end
  # }
  
  def path_to(type, index = self.id)
    case type
    when "html"
      "app/views/lesson/#{self.lesson.id}/_step_#{index}.html.erb"
    when "coffee"
      "app/assets/javascripts/#{self.lesson.id}/step_#{index}.coffee"
    when "scss"
      "app/assets/stylesheets/#{self.lesson.id}/step_#{index}.scss"
    when "ajax"
      "app/views/user_progresses/lesson_#{self.lesson.id}_step_#{index}.js.erb"
    end
  end
    
  private
    
    def update_indices(condition, change, index)
      if condition
        next_step = Step.find_by(lesson: self.lesson, index: index)
        if next_step
          next_step.update_attribute(:index, index + change)
        end
      end
    end
    
    def process_file(previous, new)
      html_contents = File.read(path_to("html", self.id)).gsub("id=\"#{self.lesson.id}-#{previous}\"", "id=\"#{self.lesson.id}-#{new}\"")
      File.open(path_to("html", self.id), "w") {|file| file.puts(html_contents)}
      # File.rename(path_to("html", previous), path_to("html", "#{new}#{extension}"))
     
      js_contents = File.read(path_to("coffee", self.id)).gsub("\##{self.lesson.id}-#{previous}", "\##{self.lesson.id}-#{new}")
      File.open(path_to("coffee", self.id), "w") {|file| file.puts(js_contents)}
      # File.rename(path_to("js", previous), path_to("js", "#{new}#{extension}"))
      
      scss_contents = File.read(path_to("scss", self.id)).gsub("\##{self.lesson.id}-#{previous}", "\##{self.lesson.id}-#{new}")
      File.open(path_to("scss", self.id), "w") { |file| file.puts(scss_contents)}
      # File.rename(path_to("scss", previous), path_to("scss", "#{new}#{extension}"))
      
      # File.rename(path_to("ajax", previous), path_to("ajax", "#{new}#{extension}"))
    end
end