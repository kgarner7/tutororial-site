class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  rescue_from "Exception" do |exception|
    line_num = Integer(exception.backtrace[0].split(":")[1]) - 3
    begin
      (@step = Step.find(params.require :target))
      Log.create({read: false, file_name: @step.path_to("html"), error: "'#{exception.message}' at line #{line_num - 65}", previous_code: File.read(@step.path_to "html")})
      File.open(@step.path_to("html"), "w+") {|file| file.puts Message.where(file_name: @step.path_to("html")).last().previous_code}
      render 'layouts/reload'
    rescue
      raise exception
    end
  end


  private
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end