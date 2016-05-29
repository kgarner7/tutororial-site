class UserProgressesController < ApplicationController
  def update
    progress = user_progress
    @count = 0
    unless session[:admin]
      @count = 0
      progress.step.step_actions.each do |action|
        correct = true
        if action.action_type == "multiple-radio"
          if exists? action.answers.first.unique_hash
            correct = params.require(action.answers.first.unique_hash) == action.answers.where(correct: true).first.answer
          else
            correct = false
          end
        else
          action.answers.each do |answer|
            if exists? answer.unique_hash
              correct = params.require(answer.unique_hash) == answer.answer
              correct = false unless answer.correct
            else
              correct = false if answer.correct
            end
          end
        end
        
        @count += 1 if correct
      end
      @max_score = progress.step.score
      if @count > progress.score
        progress.update_attribute(:score, @count)
      end
      respond_to do |format|
        format.js { render "lesson_#{progress.step.lesson.id}_step_#{progress.step.id}"}
        format.json {render json: @count, location: @count }
        format.json {render json: @max_score, location: @max_score}
      end
    else
      @max_score = 1000
      respond_to do |format|
        format.js { render "lesson_#{progress.step.lesson.id}_step_#{progress.step.id}"}
        format.json {render json: @count, location: @count }
        format.json {render json: @max_score, location: @max_score}
      end    
    end    
  end
  
  def change_score
  end
  
  private
    def user_progress
      UserProgress.find_by(unique_hash: params.require(:unique_hash))
    end
    
    def exists?(param)
      params.require(param) rescue false
    end
end