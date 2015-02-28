class AnswersController < ApplicationController
	before_action :set_answer, except: [:create]
	def create
		@answer = Answer.new(answer_params)
		@answer.save
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
      params.require(:answer).permit(:answer, :value, :question_id)
    end
end
