class Match < ActiveRecord::Base
	belongs_to :team_1, class_name: 'Team', foreign_key: 'team_1_id'
	belongs_to :team_2, class_name: 'Team', foreign_key: 'team_2_id'

	has_many :user_match_relationships, as: :matchable, dependent: :destroy
	has_many :users, through: :user_match_relationships

	#-----Validations
	validates_presence_of :team_1_id, :team_2_id





	def users_team_1
		self.users.merge(UserMatchRelationship.team_1)
	end

	def users_team_2
		self.users.merge(UserMatchRelationship.team_2)
	end

	def close_match(winner_id,loser_id)
		Team.find(winner_id).won()
		Team.find(loser_id).lost()
	end


	def compute_vote(team_no,user_id)
		rel = self.user_match_relationships.find_by_user_id(user_id)
		if(rel.nil? or rel.voted)
			return false
		end
		
		if(team_no=="1")
			rel.update_attribute(:voted,true)

			self.update_attribute(:votes_team_1, self.votes_team_1 + 1)
			if(self.votes_team_1 > 5)
				self.update_attribute(:team_1_won, true)
				self.update_attribute(:finished, true)
				close_match(self.team_1_id,self.team_2_id)
			end
		elsif(team_no=="2")
			rel.update_attribute(:voted,true)
			self.update_attribute(:votes_team_2, self.votes_team_2 + 1)
			if(self.votes_team_2 > 5)
				self.update_attribute(:team_1_won, false)
				self.update_attribute(:finished, true)
				close_match(self.team_2_id,self.team_1_id)
			end
		end
	end

	def can_vote?(user_id)
		rel = self.user_match_relationships.find_by_user_id(user_id)
		if rel.nil?
			return false
		else
			return !rel.voted
		end
	end

	scope :matched, lambda{ |pid| where('team_1_id = ? OR team_2_id = ?', pid,pid) }
end
