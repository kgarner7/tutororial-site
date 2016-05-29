module SessionsHelper
  def log_in (student)
    reset_session
    session[:admin] = student.admin
    session[:student_id] = student.id
  end
  
  def current_student
    if (student_id = session[:student_id])
      @current_student ||= Student.find_by(id: student_id)
    elsif (student_id = cookies.signed[:student_id])
      student = Student.find_by(id: student_id)
      if student && student.authenticated?(cookies[:remember_token])
        log_in student
        @current_student = student
      end
    else
    end
  end
  
  def remember(student)
    student.remember
    cookies.permanent.signed[:student_id] = student.id
    cookies.permanent[:remember_token] = student.remember_token
  end
  
  def forget(student)
    cookies.delete(:student_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_student)
    reset_session
    @current_student = nil
  end
  
  def logged_in?
    if current_student
      current_student.id != nil
    end
  end
  
  def current_student?(student)
    student == current_student
  end
 
 def set_errors(errors = {}, object = "")
   errors["object"] = "#{object}"
   session[:errors] = errors
   
 end
 
 def any_errors?(object)
   session[:errors] ||= Hash.new
   if session[:errors]["object"] == "#{object}"
    session[:errors].length > 1
   end
 end
 
 def errors(object)
   if session[:errors]["object"] == object
     error = Hash.new
     session[:errors].delete("object")
     error.update(session[:errors])
     session[:errors] = {}
     error
   end
 end
 
  def num_errors
   session[:errors].length - 1
  end
 
 def store_target(target_url)
   session[:target] = target_url
 end
 
 def target_url
   @target = session[:target]
   session.delete(:target)
 end
 
 def set_data(source, data = {})
   session[:source] = source
   data.each do |key, value|
     session["#{source.crypt("qX")}#{key}"] = value
   end
 end
 
 def any_data?(source)
   session[:source] == source
 end
 
 def get_data(source, *expected_data)
   if session[:source] == source
     data = {}
     expected_data.each do |datum|
       data[datum] = session["#{source.crypt("qX")}#{datum}"]
       session.delete("#{source.crypt("qX")}#{datum}")
     end
     session.delete(:source)
     data
   end
 end
end