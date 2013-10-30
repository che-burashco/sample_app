class SessionsController < ApplicationController
	def new
	end

	def create
		user = User.find_by(email: params[:session][:email])
		if user && user.authenticate(params[:session][:password])
		else
			flash.now[:error] = "Invalid email/password combination"
			render 'new'
		end
	end

	def edit
	end

	def delete
	end
end
