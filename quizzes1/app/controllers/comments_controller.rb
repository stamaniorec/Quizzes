class CommentsController < ApplicationController
  def create
    @quiz = Quiz.find(params[:quiz_id])
    @comment = @quiz.comments.new(comment_params)
    @comment.user = current_user
    
    if @comment.save
      redirect_to @quiz, notice: 'Comment was successfully created.'
    else
      redirect_to @quiz, notice: 'Comment is empty, cannot post.'
    end
  end

  def edit
  	@comment = Comment.find(params[:id])
  	@quiz = Quiz.find(params[:quiz_id])
  end

  def update
    @comment = Comment.find(params[:id])
    
    if @comment.update(comment_params)
      redirect_to quiz_path(@comment.quiz), notice: 'Comment was successfully updated.'
    else
      redirect_to quiz_path(@comment.quiz), notice: 'Comment is empty, cannot update.'
    end
  end

  def destroy
    Comment.find(params[:id]).destroy
    redirect_to :back, notice: 'Comment was successfully destroyed.'
  end

  private

  def comment_params
    params.require(:comment).permit(:quiz_id, :body, :user_id, :id)
  end

end
