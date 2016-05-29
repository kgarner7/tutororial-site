class LessonsController < ApplicationController
   before_action :logged_in_user?
   before_action :admin_user, only: [:edit, :create_lesson, :update_lesson, :destroy_lesson]

  def create_lesson
    Lesson.create({name: params.require(:name)})
    redirect_to :back
  end

  def update_lesson
    @lesson = Lesson.find(params.require :id)
    @lesson.update_attribute(:name, params.require(:name))
    redirect_to :back
  end

  def destroy_lesson
    lesson = Lesson.find(params.require :id) rescue nil
    if lesson
      lesson.destroy
    end
    redirect_to :back
  end

  def create
    error = params.require(:error) rescue "An error occurred in the file"
    @step = Step.find(params.require(:id))  
    type = params.require :type
    if type === "coffee" || type === "ajax"
      code = File.read(@step.path_to(type))
      File.open("file.txt", "w+") {|file| file.puts(error+ " " + code)}
      Log.create({file_name: @step.path_to(type), error: error, previous_code: code, read: false})      
      File.open(@step.path_to(type), "w+") {|file| file.puts(Message.where(file_name: @step.path_to(type)).last().previous_code)}
      Message.create({file_name: @step.path_to(type), file_type: type, previous_code: File.read(@step.path_to(type))})
      @type = type
      respond_to do |format|
        format.js {}
        format.json {render json: @step}
        format.json {render json: @type, location: @type}
      end
    else
      Log.create({error: "Something really went wrong", file_name: "unknown"})
    end
  end

  def show
    @lesson = Lesson.find(id)
    @target = params.require :target
    @method = params.require(:method) rescue "";
    @test = params.require(:test) rescue "";
    @admin = session[:admin]
    if @target != "main page"
      process_step
    end
  end
  
  def show_step_action
    @step_action ||= StepAction.find(params.require(:id))
    respond_to do |format|
      format.js {}
      format.json { render json: @step_action, location: @step_action }
    end
  end
  
  def new_action_step
    @step = Step.find(params.require(:id))
    @index = @step.step_actions.count + 1
    respond_to do |format|
      format.js {}
      format.json { render json: @index, location: @index }
      format.json { render json: @step, location: @step }
    end
  end
  
  def create_action_step
    step = Step.find(params.require(:id))
    @step_action = step.step_actions.build(params.require(:step_action).permit(:index, :score, :action_type))
    value = ""
    params.require(:answer).each do |meh, stuff|
      if @step_action.action_type == "content"
        value = SecureRandom.urlsafe_base64() + ", "
      elsif @step_action.action_type.index("multiple").nil?
        value += "#{stuff[:answer]}, "
      else
        value += "#{stuff[:answer]}#{stuff[:correct] == "1" ? "-correct": ""}, "
      end
    end
    value = value[0..value.length - 3]
    @step_action.value = value
    @step_action.save
    
    redirect_to :back
  end
  
  def remove_step_action
    StepAction.find(params.require(:id)).destroy
    redirect_to :back
  end
  
  def update_step_actions
    @step_action = StepAction.find(params.require(:id))
    if params.require(:answer).length > 1 && params.require(:step_action)[:action_type].index("multiple").nil?
      meh
    else
      params.require(:answer).each do |answer|
        answer[1][:correct] = answer[1][:correct] == "1"
        stuff = @step_action.answers.find_by(index: answer[1].permit(:index)[:index])
        if stuff
          stuff.update_attributes(answer[1].permit(:answer, :index, :correct))
        else
          @step_action.answers.create(answer[1].permit(:answer, :index, :correct))
        end
      end
      unless @step_action.update_attributes(params.require(:step_action).permit(:index, :score, :action_type))
        merh
      end
    end
    redirect_to :back
  end
  
  def remove_answer
    @unique_hash = params.require(:answer)
    step_action = StepAction.find(params.require(:step_action))
    
    @destroyed = step_action.answers.find_by(unique_hash: @unique_hash).destroy unless step_action.answers.count == 1
    respond_to do |format|
      format.js {}
      format.json { render json: @unique_hash, location: @unique_hash} if @destroyed
      format.json { render json: @destroyed, location: @destroyed}
    end
  end
  
  def edit
    @code = {"html" => "", "coffee" => "", "scss" => "", "ajax" => ""}
    @errors = {"html" => "", "coffee" => "", "scss" => "", "ajax" => ""}
    @lesson = Lesson.find(id)
    @target = params.require :target
    if @target != "main page"
      process_step
      ["html", "coffee", "scss", "ajax"].each do |type|
        if log = Log.where(file_name: @user_progress.step.path_to(type), read: false).last
          @errors[type] = log.error
          case type
          when "coffee"
            log.previous_code.split("#content\n")[1].split("\n").each {|line| @code["coffee"] << line[6..line.length] + "\n"}
          when "scss"
            array = log.previous_code.split("\n")
            array[1..array.length - 2].each {|line| @code["scss"] << line[2..line.length + 1] + "\n"}
          when "ajax"
            @code[type] = log.previous_code
          when "html"
            array = log.previous_code.split("\n")
            array[3..array.length].each {|line| @code["html"] << line[4..line.length + 1] + "\n"} rescue "";
          end
          log.update_attribute(:previous_code, nil)
          log.update_attribute :read, true
        end
      end
    end
    

    unless session[:upload_success].nil?
      @success = session[:upload_success]
      session.delete(:upload_success)
    end
  end
  
  def update_step
    @step = Step.find(params.require :id)
    @success = @step.update_attributes(step_params)
    redirect_to :back
  end
  
  def update_steps
    @step = Step.find(params.require :step)
    paths = ["coffee", "ajax", "scss", "html"]
       
    paths.each do |type|
      Message.create({student: current_student, file_name: @step.path_to(type), file_type: type, previous_code: File.read(@step.path_to type)})
    end
    
    scss_string = "#step-#{@step.id} {\n"
    params.require(:scss).split("\n").each {|string| scss_string += "  #{string.gsub("\r", "")}\n"} rescue "";
    File.open(@step.path_to("scss"), "w+") {|file| file.puts(scss_string + "}")}
    
    js_strings = File.read(@step.path_to("coffee")).split"#content\n"
    js_strings[1] = ""
    params.require(:coffee).split("\n").each {|string| js_strings[1] += "      #{string.gsub("\r", "")}\n"} rescue "";
    File.open(@step.path_to("coffee"), "w+") {|file| file.puts js_strings[0] + "#content\n" + js_strings[1] + "#content\n" + js_strings[2]}
    
    
    html_string = "<div id=\'step-#{@step.id}\'>\n    <h2 class=\"text-center\"><%=Step.find_by(lesson: @lesson, id: @target).name%></h2>\n    <h3 id=\"step-error\" class=\"text-center errors-content\"></h3>\n"
    params.require(:html).split("\n").each {|string| html_string += "    #{string.gsub("\r","")}\n"} rescue "";
    File.open(@step.path_to('html'), "w+") {|file| file.puts(html_string + "\n")}
    
    File.open(@step.path_to("ajax"), "w+") {|file| file.puts(params.require(:ajax).gsub("\r", ""))}  rescue "";
    
    redirect_to lesson_path @step.lesson, target: @step.id, method: "reload", test: 1
  end
  
  def create_step
    @step = Lesson.find(params.require(:id)).steps.create(step_params)
    redirect_to :back
  end
  
  def remove_step
    @step = Step.find(params.require(:id))
    @step.destroy
    redirect_to :back
  end
  
  def reset_file
    
  end
  
  private
    def id
      Integer params.require :id
    end
  
    def logged_in_user?
      if current_student
        true
      else
        redirect_to root_url
      end
    end
    
    def admin_user
      unless current_student.admin
        redirect_to root_url
      end
    end
    
    def step_params
      params.require(:step).permit(:name, :index)
    end
    
    def process_step
      step = @lesson.steps.find(@target)
      @user_progress = UserProgress.find_by(lesson: @lesson, step: step, student: current_student)
      next_step =  @lesson.steps.where("id > #{step.id}").first
      previous_step = @lesson.steps.where("id < #{step.id}").last
      next_lesson = Lesson.where("id > #{@lesson.id}").first
      previous_lesson = Lesson.where("id < #{@lesson.id}").last
            
      if next_step
        @next_path = lesson_path(@lesson, target: next_step.id)
      elsif next_lesson
        @next_path = lesson_path(next_lesson, target: "main page")
      else
        @next_path = lesson_path(@lesson, target: "main page")
      end
      
      if previous_step
        if UserProgress.find_by(step: previous_step, student: current_student).score < previous_step.score / 2.0
          redirect_to lesson_path(@lesson, target: "main page")
        end
        @previous_path = lesson_path @lesson, target: previous_step.id
      elsif previous_lesson
        @previous_path = lesson_path(previous_lesson, target: "main page")
      else
        @previous_path = lesson_path(@lesson, target: "main page")
      end      
    end
end