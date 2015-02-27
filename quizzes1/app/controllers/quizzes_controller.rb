require 'quiz_master'

class QuizzesController < ApplicationController
  before_action :set_quiz, only: [:show, :edit, :update, :destroy, :create_question, :edit_question]
  before_action :authenticate_user!, except: [:index, :show]

  # GET /quizzes
  # GET /quizzes.json
  def index
    @quizzes = Quiz.all
  end

  # GET /quizzes/1
  # GET /quizzes/1.json
  def show
    @quiz_variant = build_quiz_variant
    @score = Score.new
  end

  # GET /quizzes/new
  def new
    @quiz = current_user.quizzes.build
  end

  # GET /quizzes/1/edit
  def edit
  end

  # POST /quizzes
  # POST /quizzes.json
  def create
    @quiz = current_user.quizzes.build(quiz_params)

    respond_to do |format|
      if @quiz.save
        format.html { redirect_to @quiz, notice: 'Quiz was successfully created.' }
        format.json { render :show, status: :created, location: @quiz }
      else
        format.html { render :new }
        format.json { render json: @quiz.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quizzes/1
  # PATCH/PUT /quizzes/1.json
  def update
    respond_to do |format|
      if @quiz.update(quiz_params)
        format.html { redirect_to @quiz, notice: 'Quiz was successfully updated.' }
        format.json { render :show, status: :ok, location: @quiz }
      else
        format.html { render :edit }
        format.json { render json: @quiz.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quizzes/1
  # DELETE /quizzes/1.json
  def destroy
    @quiz.destroy
    respond_to do |format|
      format.html { redirect_to quizzes_url, notice: 'Quiz was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def create_question
  end
  
  def edit_question
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quiz
      @quiz = Quiz.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def quiz_params
      params.require(:quiz).permit(:name)
    end

    # Builds a quiz variant out of a given quiz from the database
    # I.e. You get a random ordering of the questions and the answers
    # Returns nil if the quiz is empty
    # Or a QuizMaster::QuizVariant instance if it isn't
    def build_quiz_variant
      quiz_content = Array.new

      @quiz.question.all.each do |question|
        question_hash = Hash.new
        question_hash[:prompt] = question.question

        answers = Array.new
        correct_answer = question.correct

        1.upto(6) do |ans_num|
          cur_answer = eval("question.ans#{ans_num}")
          if cur_answer
            answers << QuizMaster::Answer.new(cur_answer, correct_answer == ans_num)
          end
        end

        question_hash[:answers] = answers
        quiz_content << question_hash
      end

      quiz_content.map! { |q| QuizMaster::Question.new(q) }

      quiz = QuizMaster::Quiz.new(quiz_content)

      if quiz_content.empty?
        nil
      else
        answer_reorderings = quiz.answer_reordering_vectors
        question_reordering = quiz.question_reordering_vector

        QuizMaster::QuizVariant.new(quiz, answer_reorderings, question_reordering)
      end
    end
end
