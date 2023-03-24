module ApplicationHelper
	def username(user)
		user = user.first_name + ' ' + user.last_name
		return user
	end
end
