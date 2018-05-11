class UserTeamRelationship < ActiveRecord::Base
	belongs_to :user, class_name: 'User', foreign_key: :user_id
	belongs_to :team, class_name: 'Team', foreign_key: :team_id

	#-----Validations
	validates_presence_of :user_id, :team_id

	scope :accepted, -> { where(accepted: true)}
end
