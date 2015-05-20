class ScoresController < ApplicationController
  before_action :set_score, only: [:show]
  before_action :check_authentication, only: [:show]

  def index
    @scores = Score.all
  end

  def show
  end

  def create
    num_questions = params[:answer].length
    num_correct = 0

    0.upto(num_questions - 1) do |question_index|
      answered_correctly = params[:answer][question_index.to_s] == params[:correct][question_index.to_s]
      if answered_correctly
        num_correct += 1
      end
    end

    score = num_correct / num_questions.to_f * 100 # convert to percentage

    points_to_award = num_correct * 1

    @score = Score.new(score: score.to_i, quiz_id: params[:quiz_id], user_id: params[:user_id])
    if user_signed_in?
      current_user.add_points(points_to_award, category: 'Play')
    end

    if @score.save
      if user_signed_in?
        redirect_to @score,
          notice: "Congratulations! You won #{points_to_award} #{'point'.pluralize points_to_award}!"
      else
        redirect_to @score,
          notice: 'Please log in in order to save your scores and have fun with your friends!'
      end
    else
      redirect_to root_path, alert: 'Whoops, something went wrong. Your score could not be saved.'
    end
  end

  private
    def score_params
      params.require(:score).permit(:score, :quiz_id)
    end

    def set_score
      @score = Score.find(params[:id])
    end

    def check_authentication
      if !user_signed_in? || (@score.user != current_user)
        redirect_to quizzes_path
        flash[:alert] = 'This score is not for you to see.' 
      end
    end
end
