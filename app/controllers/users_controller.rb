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
    #binding.pry

    params[:user].values.each do |u|
      #binding.pry
       @user = User.find(u[:user_id])
       @user.row_order = u[:row_order_position]
       @user.save
    end
    # @user = User.find(params[:user][:user_id])
    # @user.row_order = params[:user][:row_order_position]
    # @user.save

    render nothing: true # this is a POST action, updates sent via AJAX, no view rendered
  end

  def index
    @users = User.order(params[:sort].to_s + " " + params[:direction].to_s)
    #@users = User.rank(:row_order).all
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

   def sort
    User.all.each do |spec|
      if position = params[:specifications].index(spec.id.to_s)
        spec.update_attribute(:position, position + 1) unless spec.position == position + 1
      end
    end
    render :nothing => true, :status => 200
  end

  private

   def user_params
    params.require(:user).permit(:email, :firstname, :lastname, :password, :password_confirmation, :confirm_token, :admin, :email_confirmed )
  end
end
