require 'quiz_master'

class QuizzesController < ApplicationController
  before_action :set_quiz, only: [:show, :edit, :update, :destroy, :check_authentication]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :check_authentication, only: [:edit, :destroy, :create_question]

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
    @quiz.questions.build
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
  
  def check_authentication
    if @quiz.user != current_user
      redirect_to quizzes_path
      flash[:notice] = 'Can be modified only by the owner.' 
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quiz
      @quiz = Quiz.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def quiz_params
      params.require(:quiz).permit(
        :name, :user_id, :shuffled,
        questions_attributes: [:id, :question_id, :question, :quiz_id, :_destroy, 
          answers_attributes: [:id, :answer_id, :question_id, :value, :is_correct, :anchored, :_destroy]
        ])
    end

    # Builds a quiz variant out of a given quiz from the database
    # I.e. You get a random ordering of the questions and the answers
    # Returns nil if the quiz is empty
    # Or a QuizMaster::QuizVariant instance if it isn't
    def build_quiz_variant
      quiz_content = Array.new
      
      @quiz.questions.all.each do |question|
        question_hash = Hash.new
        question_hash[:prompt] = question.question
        
		    answers = Array.new
        
        question.answers.all.each do |cur_answer|
       		answers << QuizMaster::Answer.new(cur_answer.value, cur_answer.is_correct, anchored: cur_answer.anchored)
        end
		
        question_hash[:answers] = answers
        quiz_content << question_hash
      end

      quiz_content.map! { |q| QuizMaster::Question.new(q) }

      quiz = QuizMaster::Quiz.new(quiz_content)

      if quiz_content.empty?
        nil
      elsif @quiz.shuffled?
        answer_reorderings = quiz.answer_reordering_vectors
        question_reordering = quiz.question_reordering_vector

        QuizMaster::QuizVariant.new(quiz, answer_reorderings, question_reordering)
      else
        quiz
      end
    end
end
