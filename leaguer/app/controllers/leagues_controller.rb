class LeaguesController < ApplicationController
	include LeaguesHelper


	def show
		@users = get_users(params[:user_page]) #params[:page])
		@matches = get_matches(params[:match_page])
		@teams = get_teams(params[:team_page])
	end
end
