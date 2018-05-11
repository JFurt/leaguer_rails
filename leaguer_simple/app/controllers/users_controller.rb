class UsersController < ApplicationController
	before_action :signed_in_user, only: [:edit,:index, :update, :destroy]
	before_action :correct_user, only: [:edit, :update, :accept_invite]
	before_action :admin_user, only: :destroy

	before_action :load_variables
	def new
		@user = User.new
		if signed_in?
			redirect_to user_path current_user
		end
	end
	def create
		@user = User.new(user_params)
		if @user.save
			flash[:success] = "Welcome to Leaguer!"
			sign_in @user
			redirect_to @user
		else
			render 'new'
		end
	end

	def show
		@inviting_teams_rel = @user.inviting_teams
		@teams = @user.accepted_teams
	end

	def edit
	end

	def update
		if @user.update_attributes(user_params)
			flash[:success] = "Profile updated"
			redirect_to @user
		else
			render 'edit'
		end
	end	

	def index
		@users = User.paginate(page: params[:page])
	end

	def destroy
		@user.destroy
		flash[:success] = "User deleted."
		redirect_to users_url
	end

	def accept_invite
		@user.accept_invite(params[:team_id])
		redirect_to team_path(params[:team_id])
	end

	private
		def load_variables
			@user = User.find(params[:id]) unless params[:id].nil?
		end


		def user_params
		  params.require(:user).permit(:name, :email, :password,
		                               :password_confirmation)
		end

		# Before filters

		def signed_in_user
			unless signed_in?
				store_location
				redirect_to signin_url, notice: "Please sign in."
			end
		end		

		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_url) unless current_user?(@user)
		end	

		def admin_user
			redirect_to(root_url) unless current_user.admin?
		end	

		def correct_user?
			@user = User.find(params[:id])
			current_user?(@user)
		end

		helper_method :correct_user?
end
