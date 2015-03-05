class ScoresController < ApplicationController

  def index
    @scores = Score.all
  end

  def show
    @score = Score.find(params[:id])
  end

  def create
    num_questions = params[:answer].length
    num_correct = 0

    points_to_award = 0

    0.upto(num_questions - 1) do |question_index|
      answered_correctly = params[:answer][question_index.to_s] == params[:correct][question_index.to_s]
      if answered_correctly
        num_correct += 1
        points_to_award += 1
      end
    end

    score = num_correct / num_questions.to_f * 100 # convert to percentage

    @score = Score.new(score: score.to_i, quiz_id: params[:quiz_id], user_id: params[:user_id])
    current_user.add_points(points_to_award * 1, category: 'Play')
    
    respond_to do |format|
      if @score.save
        format.html { redirect_to @score, notice: 'Score was successfully created.' }
        format.json { render :show, status: :created, location: @score }
      else
        format.html { render :new }
        format.json { render json: @score.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @score.destroy
    respond_to do |format|
      format.html { redirect_to scores_url, notice: 'Score was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def score_params
      params.require(:score).permit(:score, :quiz_id)
    end
end
