class UsersController < ApplicationController
	before_action :set_user, only: :show
  def index
  	@users = User.all
  end
  
  def show 
  	@user = User.find(params[:id])
  	@quizzes = @user.quizzes.all
  	@scores = @user.scores.all
  end
  
private
	def set_user
      @user = User.find(params[:id])
    end

	def user_params
      params.require(:user).permit(:email, :encrypted_password , :reset_password_token, :reset_password_sent_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :created_at, :updated_at)
    end
end
