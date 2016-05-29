class StepActionValidator < ActiveModel::Validator
  def validate(step_action)
    if step_action.step.step_actions.find_by(index: step_action.index) && step_action.step.step_actions.find_by(index: step_action.index) != step_action
      step_action.errors[:index] << "Index must be unique"
    else
    end
  end
end

class StepAction < ActiveRecord::Base
  belongs_to :step
  has_many :answers, dependent: :destroy
  validates :value, :action_type, presence: true
  default_scope -> { order(index: :asc) }
  validates_with StepActionValidator
  
  before_create {
    self.temp_score = 0
    self.score = 0 unless self.score
    step_actions = self.step.step_actions
    count = step_actions.count
    if count == 0
      self.index = 1
    else
      if self.index
        if self.index > count + 1
          self.index = count + 1
        else
          self.temp_index = self.index
          step_actions.where("index >= #{self.index}").find_each do |action|
            action.update_attribute(:index, action.index + 1)
          end
        end
      else
        self.index = count + 1
      end
    end
    self.temp_index = self.index
  }
  
  after_create {
    File.open(html_path, "a") do |file|
      file.puts "    <div id=\'answer-#{self.index}\'>\n"
    end
    if self.action_type.index("multiple")
      self.value.split(", ").each do |value|
        if value.index("-correct") 
          self.answers.create({answer: value.gsub("-correct", ""), correct: true, answer_type: self.action_type.gsub("multiple-", "")})
        else
          self.answers.create({answer: value.gsub("-correct", ""), correct: false, answer_type: self.action_type.gsub("multiple-", "")})
        end
      end
    else
      self.answers.create({answer: self.value, correct: true, answer_type: self.action_type})
    end
    File.open(html_path, "a") do |file|
      file.puts "    </div>\n"
    end
    self.step.update_attribute(:score, self.step.score + self.score)
    self.temp_score = self.score
  }
  
  before_update {
    self.step.update_attribute(:score, self.step.score - self.temp_score)
    unless self.index == self.temp_index
      lines = File.read(html_path).gsub("id=\'answer-#{self.temp_index}\'", "id=\'answer-#{self.index}\'")
      File.open(html_path) {|file| file.puts lines}
      self.temp_index = self.index
    end
  }
  
  after_update {
    self.step.update_attribute(:score, self.step.score + (self.temp_score = self.score))
  }
  
  after_destroy {
    self.step.update_attribute(:score, self.step.score - self.score)
    stuffs = ""
    found = false
    spacing = ""
    IO.readlines(self.step.path_to("html")).each do |line|
      if line.index("<div id=\'answer-#{self.index}\'>\n")
        spacing = line.gsub("<div id=\'answer-#{self.index}\'>\n", "")
        found = true
      elsif line == "#{spacing}</div>\n"
        found = false
        next
      end
      unless found
        stuffs += line
      end
    end
    File.open(self.step.path_to("html"), "w+") {|file| file.puts stuffs}
  }
  
  private
    def html_path
      "app/views/lesson/#{self.step.lesson.id}/_step_#{self.step.id}.html.erb"
    end
end