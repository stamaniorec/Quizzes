class CommentsController < ApplicationController
  before_action :set_quiz, only: [:create, :edit]
  before_action :set_comment, except: [:create]
  before_action :authenticate_user!, only: [:create]

  def create
    @comment = @quiz.comments.build comment_params
    @comment.user = current_user
    
    if @comment.save
      redirect_to @quiz, notice: 'Comment was successfully posted. You won 1 point.'
    else
      redirect_to @quiz, alert: 'Comment is empty, cannot be posted.'
    end
  end

  def edit
  end

  def update    
    if @comment.update comment_params
      redirect_to quiz_path(@comment.quiz), notice: 'Comment was successfully updated.'
    else
      redirect_to quiz_path(@comment.quiz), alert: 'Comment is empty, cannot update.'
    end
  end

  def destroy
    if @comment.destroy
      redirect_to :back, notice: 'Comment was successfully deleted.'
    else
      redirect_to :back, alert: 'Your comment could not be deleted.'
    end
  end

  private

    def comment_params
      params.require(:comment).permit(:quiz_id, :body, :user_id, :id)
    end

    def set_quiz
      @quiz = Quiz.find params[:quiz_id]
    end

    def set_comment
      @comment = Comment.find params[:id]
    end

end
