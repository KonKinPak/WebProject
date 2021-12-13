module MainConcern
	extend ActiveSupport::Concern

	included do
		helper_method :is_logged_in
	end


	def is_logged_in
		if !session[:user_id]
			redirect_to feed_path, alert: "Please Login First"
		else 
			return true
		end
	end

	def is_right_user(user_id)
		if(session[:user_id] != user_id)
			redirect_to feed_path, alert: "That's not yours"
		else
			return true
		end
	end

	def is_admin
		:is_logged_in
		user = User.find(session[:user_id])
		if(user.admin)
			return true
		else
			redirect_to feed_path, alert: "You don't have permission to access this site"
		end
	end
end