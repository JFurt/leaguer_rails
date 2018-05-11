class User < ActiveRecord::Base
	before_save { self.email = email.downcase }
	before_create :create_remember_token

	has_many :user_team_relationships, class_name: 'UserTeamRelationship', foreign_key: :user_id, dependent: :destroy
	has_many :teams, class_name: 'Team', through: :user_team_relationships
	
	validates :name, presence: true, length: {maximum: 50}
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false}

	has_many :user_match_relationships, class_name: 'UserMatchRelationship', foreign_key: :user_id, dependent: :destroy
	has_many  :pre_matches, class_name: 'PreMatch', through: :user_match_relationships, source: :matchable, source_type: 'PreMatch'
	has_many  :matches, class_name: 'Match', through: :user_match_relationships, source: :matchable, source_type: 'Match'


	has_secure_password
	validates :password, length: { minimum: 6 }
	validates :password_confirmation, length: { minimum: 6 }

	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.digest(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	def inviting_teams
		self.user_team_relationships.where('accepted = ?',false)
	end

	def accept_invite(team_id)
		rel = self.user_team_relationships.find_by_team_id(team_id)
		rel.update_attribute(:accepted, true) unless rel.nil?
	end

	def accepted_teams
		self.teams.merge(UserTeamRelationship.accepted)
	end

	private

		def create_remember_token
			self.remember_token = User.digest(User.new_remember_token)
		end
end
