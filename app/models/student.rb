class Student < ActiveRecord::Base
  validates :username, presence: true, length: {maximum: 50}, uniqueness: { case_sensitive: true }
  validates :password, presence: true, length: { minimum: 8 }
  has_many :user_progresses, dependent: :destroy
  belongs_to :message

  after_create {
    Lesson.all.each do |lesson|
      lesson.steps.all.each do |step|
        self.user_progresses.create({step: step, lesson: lesson, score: 0})
      end
    end
  }
  
  has_secure_password

  def Student.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  def Student.new_token
    SecureRandom.urlsafe_base64
  end
  
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  def forget
    update_attribute(:remember_digest, nil);
  end
end
