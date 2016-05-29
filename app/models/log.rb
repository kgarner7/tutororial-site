class Log < ActiveRecord::Base
  attr_encrypted :previous_code
  validates :encrypted_previous_code, symmetric_encryption: true
end