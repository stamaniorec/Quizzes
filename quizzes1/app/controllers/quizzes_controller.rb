require 'quiz_master'

class QuizzesController < ApplicationController
  before_action :set_quiz, only: [:show, :edit, :update, :destroy, :check_authentication, :upvote, :downvote]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :check_authentication, only: [:edit, :destroy]

  def index
    @quizzes = Quiz.paginate(:page => params[:page], :per_page => 4)
    if params[:quiz_search]
      if params[:quiz_search].blank?
        redirect_to root_path
      else
        @quizzes = @quizzes.search_for params[:quiz_search]
      end
    end
  end

  def show
    @quiz_variant = build_quiz_variant
    @score = Score.new
  end

  def new
    @quiz = current_user.quizzes.build
    @quiz.questions.build
  end

  def edit
  end

  def create
    @quiz = current_user.quizzes.build quiz_params

    points_to_award = 0
    @quiz.questions.each { points_to_award += 1 }
    current_user.add_points(points_to_award * 3, category: 'Create')

    if @quiz.save
      redirect_to @quiz, notice: 'Quiz was successfully created.'
    else
      render :new
    end
  end

  def update
    if @quiz.update quiz_params
      redirect_to @quiz, notice: 'Quiz was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @quiz.destroy
      remove_badges_if_necessary
      redirect_to quizzes_url, notice: 'Quiz was successfully destroyed.'
    else
      redirect_to @quiz, alert: 'Quiz could not be destroyed.'
    end
  end

  def upvote
    @quiz.upvote_by current_user
    current_user.add_points 1 unless current_user.voted_for? @quiz
    redirect_to :back
  end

  def downvote
    @quiz.downvote_by current_user
    current_user.add_points 1 unless current_user.voted_for? @quiz
    redirect_to :back
  end

  private
    # Makes sure you cannot modify quizzes that do not belong to you through url
    def check_authentication
      if @quiz.user != current_user
        redirect_to quizzes_path
        flash[:alert] = 'Can be modified only by the owner.' 
      end
    end

    def set_quiz
      @quiz = Quiz.find(params[:id])
    end

    def quiz_params
      params.require(:quiz).permit(
        :name, :user_id, :shuffled,
        questions_attributes: [:id, :question_id, :question, :quiz_id, :_destroy, 
          answers_attributes: [:id, :answer_id, :question_id, :value, :is_correct, :anchored, :_destroy]
        ])
    end

    # Merit
    def remove_badges_if_necessary
      if current_user.quizzes.count < 3
        current_user.rm_badge(1)
      end
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
