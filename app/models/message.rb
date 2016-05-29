class Message < ActiveRecord::Base
  belongs_to :student
  default_scope -> { order(created_at: :asc) }
  validates :file_name, :file_type, presence: true
  
  after_create {
    Message.where(file_name: self.file_name).where.not(encrypted_previous_code: nil, id: self.id).find_each {|message| message.update_attribute(:previous_code, "")}
  }
  
  attr_encrypted :previous_code, random_iv: true
  validates :encrypted_previous_code, symmetric_encryption: true
end