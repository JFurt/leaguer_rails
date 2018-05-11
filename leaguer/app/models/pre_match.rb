class PreMatch < ActiveRecord::Base
	belongs_to :team_1, class_name: 'Team', foreign_key: 'team_1_id'
	belongs_to :team_2, class_name: 'Team', foreign_key: 'team_2_id'

	has_many :user_match_relationships, as: :matchable
	has_many :users, through: :user_match_relationships

	#-----Validations
	validates_presence_of :team_1_id, :team_2_id


	def relate_users(list_of_users,team_1_bool)
		list_of_users.each do |user|
			self.user_match_relationships.create(team_1: team_1_bool,user_id: user)
		end
	end

	def promove_to_match
		match = Match.create(team_1_id: self.team_1_id, team_2_id: self.team_2_id,
							finished: false)
		self.user_match_relationships.each do |rel|
			rel.update_attribute(:matchable_id, match.id)
			rel.update_attribute(:matchable_type, 'Match')
		end
		self.destroy
		return match
	end

	def clear_and_destroy
		self.user_match_relationships.each do |rel|
			rel.destroy
		end
		self.destroy
	end

	scope :matched, lambda{ |pid| where('team_1_id = ? OR team_2_id = ?', pid,pid) }
end
