class LeaderboardController < ApplicationController

  def show_play_leaderboard
    @top_players = Merit::Score.top_scored category: 'Play' 
  end

  def show_create_leaderboard
  	@top_creators = Merit::Score.top_scored category: 'Create'
  end

  def show_general_leaderboard
  	@top_general = Merit::Score.top_scored
  end

end
