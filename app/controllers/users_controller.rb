class UsersController < ApplicationController

  before_filter :authorize, :only => [:index, :destroy]

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

  def update_row_order
    @user = User.find(user_params[:user_id])
    @user.row_order_position = user_params[:row_order_position]
    @user.save

    render nothing: true # this is a POST action, updates sent via AJAX, no view rendered
  end

  def index
    @users = User.order(params[:sort].to_s + " " + params[:direction].to_s)
    #@users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Info updated successfully!"
      redirect_to users_path
    else
      render "edit"
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to :action => 'index'
  end

  private

   def user_params
    params.require(:user).permit(:email, :firstname, :lastname, :password, :password_confirmation, :confirm_token, :admin, :email_confirmed )
  end
end
