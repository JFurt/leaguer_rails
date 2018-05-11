class MatchesController < ApplicationController
  def show
  	@match = Match.find(params[:id])
  end

  def submit_result
  	@match = Match.find(params[:id])
  	@match.compute_vote(params[:winner],current_user.id)
  	redirect_to match_path(@match)
  end

end
