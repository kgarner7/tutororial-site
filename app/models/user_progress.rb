class UserProgress < ActiveRecord::Base
  belongs_to :step
  belongs_to :student
  belongs_to :lesson
  
  after_create { 
    self.unique_hash = SecureRandom.base64(16)
    until self.save
      self.unique_hash = SecureRandom.base64(16)
    end
    }
    
  def to_param
    unique_hash
  end
end