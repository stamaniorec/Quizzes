class SearchController < ApplicationController
  def index
    
  end
  def show
    @results = Quiz.all
    if params[:quiz_search] && !params[:quiz_search].blank?
      @results = @results.search_for params[:quiz_search]
    end
    if params[:user_search] && !params[:user_search].blank?
	  @results = @results.search_for params[:user_search], order: 'email asc'
	end
    if params[:question_search] && !params[:question_search].blank?
	  @results = @results.search_for params[:question_search]
	end
  end
end
