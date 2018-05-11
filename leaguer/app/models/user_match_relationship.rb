class UserMatchRelationship < ActiveRecord::Base
	belongs_to :matchable, polymorphic: true
	belongs_to :user, class_name: 'User', foreign_key: :user_id

	#-----Validations
	validates_presence_of :user_id, :matchable_id

	scope :pre_matched, -> { where('matchable_type = ?','PreMatch')}
	scope :team_1, -> { where(team_1: true)}
	scope :team_2, -> { where(team_1: false)}
end
