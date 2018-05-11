module LeaguesHelper


	def get_users(page)
		#fazer ordenação
		User.paginate(page: page, per_page: 8)
	end

	def get_matches(page)
		#fazer ordenação
		Match.paginate(page: page,per_page: 8)
	end

	def get_teams(page)
		#fazer ordenação
		Team.paginate(page: page,per_page: 8)
	end
end
