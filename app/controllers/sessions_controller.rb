class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.authenticate(params[:email], params[:password])

  	if user
      if user.email_confirmed
    		session[:user_id] = user.id
    		redirect_to users_url, :notice => "Logged in!"
  	  else
        flash[:error] = "Please activate your account."
      end
    else
  		flash.now.alert = "Invalid email or password"
  		render "new"
  	end
  end

   def create_fb
    user = User.omniauth(env['omniauth.auth'])
    session[:user_id] = user.id
    redirect_to users_url, :notice => "Logged in!"
  end

  def destroy
  	session[:user_id] = nil
  	redirect_to root_url, :notice => "Logged out!"
  end
end
