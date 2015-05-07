class LeaderboardController < ApplicationController

  def show
  	@top_general = Merit::Score.top_scored
  	@top_creators = Merit::Score.top_scored category: 'Create'
  	@top_players = Merit::Score.top_scored category: 'Play'
  end

end
