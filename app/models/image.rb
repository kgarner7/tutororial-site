class Image < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  before_destroy {self.remove_image!}
end
