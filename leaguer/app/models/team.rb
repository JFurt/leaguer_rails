class Team < ActiveRecord::Base
	has_many :matches_1, class_name: 'Match', foreign_key: 'team_1_id', dependent: :destroy
	has_many :matches_2, class_name: 'Match', foreign_key: 'team_2_id', dependent: :destroy

	has_many :pre_matches_1, class_name: 'PreMatch', foreign_key: 'team_1_id', dependent: :destroy
	has_many :pre_matches_2, class_name: 'PreMatch', foreign_key: 'team_2_id', dependent: :destroy

	has_many :user_team_relationships, class_name: 'UserTeamRelationship', foreign_key: :team_id, dependent: :destroy
	has_many :users, class_name: 'User', through: :user_team_relationships


	#-----Validations
	validates :name, presence: true, uniqueness: { case_sensitive: false}


	def creator(user_id)
		self.invite(user_id)
		self.user_team_relationships.find_by_user_id(user_id).update_attributes(captain: true,accepted: true)
	end

	def rank
		teams = Team.all.order('points DESC')
		teams.map(&:id).index(id) + 1
	end

	def matches
		Match.matched(id)
	end
	   
	def pre_matches
		PreMatch.matched(id)
	end

	def matches_won
		self.matches.where('team_1_id = ? AND team_1_won = ? OR team_2_id = ? AND team_1_won = ?',
			id,true,id,false)
	end

	def win_percentage
		if self.matches.count==0
			return 0
		end
		self.matches_won.count/self.matches.count
	end
	
	def invite_users(users_id)
		users_id.each do |user_id|
			self.invite(user_id)
		end
	end

	def invite(user_id)
		self.user_team_relationships.create(user_id: user_id, accepted: false)
	end

	def member?(user_id)
		rel = self.user_team_relationships.find_by_user_id(user_id)
		if rel.nil?
			return false
		else
			return rel.accepted
		end
	end

	def captain?(user_id)
		rel = self.user_team_relationships.find_by_user_id(user_id)
		if rel.nil? or !rel.captain
			return false
		end
		return true
	end


	def can_invite?(user_id)
		self.user_team_relationships.find_by_user_id(user_id).nil?
	end

	def members
		self.users.merge(UserTeamRelationship.accepted)
	end

	def matches_played(user_id)
		self.matches.joins(:user_match_relationships).where('user_id = ? AND matchable_type = ?',user_id,'Match').count
	end

	def matches_against(opponent_id)
		self.matches.where('team_1_id = ? OR team_2_id = ?',opponent_id,opponent_id)
	end

	def challenging_matches
		self.pre_matches.where('team_1_id = ?',id)
	end

	def challenged_matches
		self.pre_matches.where('team_2_id = ?',id)
	end

	def can_challenge?(opponent_id)
		self.pre_matches.where('team_1_id = ? OR team_2_id = ?',opponent_id,opponent_id).empty?
	end

	def challenging?(team_id)
		!self.pre_matches.find_by_team_1_id_and_team_2_id(self.id,team_id).nil?
	end

	def free_users
		r1=self.members.joins(:user_match_relationships).where('user_match_relationships.matchable_type <> ?', 'PreMatch').pluck(:id)
		r2=self.members.includes(:user_match_relationships).where(user_match_relationships: {user_id: nil} ).pluck(:id)
		User.where('id IN (?) OR id IN (?)',r1,r2)
	end

	def won
		self.update_attribute(:points, self.points+3)
	end

	def lost
		self.update_attribute(:points, self.points-3)
	end
end
