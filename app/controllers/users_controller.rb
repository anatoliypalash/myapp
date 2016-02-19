class UsersController < ApplicationController
  before_filter :authorize, :only => [:index, :destroy]
respond_to :html, :xml, :json

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
    params[:user].values.each do |u|
      if (@sort = current_user.sorts.find_by_sort_user_id(u[:user_id]))
        @sort.update_attribute(:sort_order, u[:row_order_position])
      else
        @sort = current_user.sorts.create(:sort_user_id => u[:user_id], :sort_order => u[:row_order_position])
      end
    end

    render nothing: true # this is a POST action, updates sent via AJAX, no view rendered
  end

  def index
   #binding.pry
    if (params["query"].present?)
      @users = User.search(params["query"])
    elsif (params[:sort].present?)
      @users = User.order(params[:sort].to_s + " " + params[:direction].to_s)
    else
      @users = User.joins("LEFT JOIN sorts ON (users.id = sorts.sort_user_id AND #{current_user.id} = sorts.user_id)").order("sorts.sort_order asc")
    end
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
    if (params[:sort])
      @users = User.order(params[:sort].to_s + " " + params[:direction].to_s)
    else
      @users = User.joins("LEFT JOIN sorts ON (users.id = sorts.sort_user_id AND #{current_user.id} = sorts.user_id)").order("sorts.sort_order asc")
    end
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      #flash[:success] = "Info updated successfully!"
      render :template => 'users/update.js.erb'
      #redirect_to users_path
      #respond_with(@user, :location => users_path)
      #render :template => 'users/update.js.erb'
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
 def user_params
    params.require(:user).permit(:email, :firstname, :lastname, :password, :password_confirmation, :confirm_token, :admin, :email_confirmed )
  end
  private


end
