class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy, :check_authentication]
  
  def create
    @question = Question.new(question_params)

    respond_to do |format|
      if @question.save
        format.html { redirect_to edit_quiz_path(@question.quiz.id), notice: 'Question was successfully created.' }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to edit_quiz_path(@question.quiz.id), notice: 'Question was successfully updated.' }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to edit_quiz_path(@question.quiz.id), notice: 'Question was successfully destroyed.' }
      format.json { head :no_content }
    end
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
