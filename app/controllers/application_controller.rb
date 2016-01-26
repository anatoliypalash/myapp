class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user


  private

  def authorize
    unless current_user
      flash[:error] = "Unauthorized access";
      redirect_to log_in_path

    end
  end


  def current_user
  	@current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
