class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      UserMailer.registration_confirmation(@user).deliver
  		redirect_to root_url, :notice => "Registration completed! Please confirm your email address."
  	else
  		render "new"
  	end
  end

  def confirm_email
    user = User.find_by_confirm_token(params[:id])
    if user
      user.email_activate
      flash[:success] = "Welcome to the Jungle baby!"
      redirect_to users_url
    else
      flash[:error] = "Error: User does not exist."
      redirect_to root_url
    end

  end

  def index
    @users = User.all
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to :action => 'index'
  end

   def user_params
    params.require(:user).permit(:email, :firstname, :lastname, :password, :password_confirmation, :confirm_token)
  end
end
