class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy, :check_authentication]
  
  def create
    @question = Question.new question_params
  end

  def update
    @question.update question_params
  end

  def destroy
    @question.destroy

  end

  private
    def set_question
      @question = Question.find(params[:id])
    end

    def question_params
      params.require(:question).permit(:question, :quiz_id, answers_attributes: 
        [:id, :answer_id, :question_id, :value, :is_correct, :anchored, :_destroy]
      )
    end
end
