class AnswersController < ApplicationController
  before_action :set_answer, except: [:create]

  def create
    @answer = Answer.create!(answer_params)
  end

  def update
    @answer.update(question_params)
  end

  def destroy
    @answer.destroy
  end
	
private
  def set_question
      @answer = Answer.find(params[:id])
    end

  def answer_params
      params.require(:answer).permit(:question_id, :value, :is_correct, :anchored)
    end
end
