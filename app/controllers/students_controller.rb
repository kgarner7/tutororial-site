class StudentsController < ApplicationController
  def new
    @student ||= Student.new
  end
  
  def show
    @student = Student.find(params.require(:id))
  end 
  
  def destroy_session 
    log_out if logged_in?
    redirect_to root_url
  end
  
  def create
    if params.require(:target) == "create"
      @student = Student.new(student_params)
      @student.admin = false;
      if @student.save
        log_in @student
        redirect_to root_url
      else
        set_errors(@student.errors.to_hash, "student")
        redirect_to :back
      end
    elsif params.require(:target) == "login"
      student = Student.find_by(username: params.require(:student).permit(:username)[:username])
      if student && student.authenticate(params.require(:student).permit(:password)[:password])
        log_in student
        redirect_to root_url
      else
        flash[:danger] = "Invalid username/password combination"
        redirect_to :back
      end
    end
  end
  
  def edit
    @student = Student.find(params.require(:id))
  end
  
  def update
    @student = Student.find(params.require(:id))
    if @student.update_attributes(student_params)
      flash[:success] = "Profile updated"
      redirect_to root_url
    else
      render 'edit'
    end
  end
  
  def change_view
    if current_student.admin
      session[:admin] = !session[:admin]
    end
    redirect_to :back
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
  
  private
    def student_params
      params.require(:student).permit(:username, :password, :password_confirmation)
    end
    
    def correct_student
      @student = Student.find(params.require(:id))
      if (!current_Student?(@student))
        redirect_to(root_url) 
      end
    end
end