class Answer < ActiveRecord::Base
  belongs_to :step_action
  validates :answer_type, :answer, presence: true
  
  before_create{
    last = Answer.where(step_action: self.step_action).last()
    if self.index
      unless last
        self.index = 1
      else 
        if self.index > last.index + 1
          self.index = last.index + 1
        else
          update(self, "index >= #{self.index}", 1)
        end
      end
    else
      unless last
        self.index = 1
      else
        self.index = last.index + 1
      end
    end
  }
  
  after_create {
    if self.answer_type != "radio" || self.step_action.answers.length == 1
      unique_hash = SecureRandom.base64 16
      until self.update_attribute(:unique_hash, unique_hash)
        unique_hash = SecureRandom.base64 16
      end
    else
      self.update_attribute(:unique_hash, self.step_action.answers.where.not(unique_hash: nil).first.unique_hash)
      
    end
    File.open(html_path, "a") do |file|
      case self.answer_type        
      when "check"
        file.puts field_tag("check_box", self.answer, ", false")
      when "radio"
        file.puts field_tag("radio_button", self.answer, ", false")
      when "text"
        file.puts field_tag("text_field")
      when "number"
        file.puts field_tag("number_field")
      else
        file.puts field_tag("hidden_field", random_value)
      end
    end
  }
  
  private
    def html_path
      "app/views/lesson/#{self.step_action.step.lesson.id}/_step_#{self.step_action.step.id}.html.erb"
    end
    
    def random_value
      SecureRandom.base64(16)
    end
    
    def field_tag(field_type, answer = "", options = "", index = self.index)
      "        <%= #{field_type}_tag '#{self.unique_hash}', '#{answer}'#{options}, id: 'answer-field-#{index}'%>\n"
    end
    
    def update(new_answer, condition, change)
      new_answer.step_action.answers.where(condition).find_each do |answer|
        answer.update_attribute(:index, answer.index + change)
      end
      html_contents = []
      IO.foreach do |line|
        if line.index("<div id='answer")
          index = Integer(line.gsub("<div id='answer", "").gsub(" ", "").gsub("'", "").gsub(">", "").gsub("\n", ""))
          if evaluate_condition(condition, index)
            line = "    <div id=\'answer-#{index + 1}\'>\n"
          end
        end
        html_contents << line
      end
      File.open(html_path, "w") do |file|
        html_contents.each {|line| file.puts line}
      end
    end
    
    def evaluate_condition(condition, value)
      if condition.index ">="
        value >= self.index
      else
        value > self.index
      end
    end
end