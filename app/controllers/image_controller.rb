class ImageController < ApplicationController
  def new
    i =  Image.new({image: params.require(:upload)})
    session[:upload_success] = i.save
    redirect_to :back
  end

  def remove
  end
end
