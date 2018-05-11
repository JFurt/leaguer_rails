class TeamsController < ApplicationController
	before_action :captain_user, only: [:invite, :send_invite,:challenge_teams,:send_challenge, :accept_challenge]
	before_action :load_variables
	def show
		@users = @team.members
		@matches = @team.matches
		@challenging_matches = @team.challenging_matches
		@challenged_matches = @team.challenged_matches
	end

	def new
		@team = Team.new
	end

	def create
		@team = Team.new(team_params)
		if @team.save
			flash[:success] = "Team Created! You can now invite users to your team!"
			@team.creator(current_user.id)
			redirect_to @team
		else
			render 'new'
		end
	end

	def index
		@teams = Team.paginate(page: params[:page])
	end

	def destroy
		@team.destroy
		flash[:success] = "Team deleted."
		redirect_to teams_url
	end	

	def invite
		@users = User.paginate(page: params[:page], per_page: 20).where('id <> ?',current_user.id)
	end

	def send_invite
		#@team.invite_users(filter_users(params[:users]))
		@team.invite(params[:invited_id])
		redirect_to invite_to_team_path
	end

	def challenge_teams
		@teams = Team.paginate(page: params[:page], per_page: 20).where('id <> ?',params[:id])
	end

	def send_challenge #Asynchronous
		@opponent = Team.find(params[:challenge_id])
		#@match = PreMatch.create(team_1_id: @team.id, team_2_id: @opponent.id)
		@pre_match=PreMatch.create(team_1_id: @team.id, team_2_id: @opponent.id)
		@pre_match.relate_users(filter_users(params[:users]),true)
		redirect_to challenge_teams_path(@team)
	end

	def accept_challenge
		@pre_match = PreMatch.find_by_team_1_id_and_team_2_id(params[:challenge_id],@team.id)
		@pre_match.relate_users(filter_users(params[:users]),false)
		@match = @pre_match.promove_to_match
		redirect_to match_path(@match)

	end

	def cancel_challenge
		@pre_match = PreMatch.find_by_team_1_id(params[:team_1_id])
		@pre_match.clear_and_destroy
		redirect_to params[:redirect_path]
	end


	private
		def load_variables
			@team = Team.find(params[:id]) unless params[:id].nil?
		end

		def filter_users(usersHash)
			users=[]
			usersHash.each do |key,value|
				users.append(key)
			end
			return users
		end

		def captain_user
			rel = current_user.user_team_relationships.find_by_team_id(params[:id])
			unless rel.nil?
				return rel.captain?
			end
			return false
		end
		def team_params
		  params.require(:team).permit(:name)
		end
end
