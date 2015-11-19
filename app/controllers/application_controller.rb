class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  def current_user
    # return nil if session[:session_token].nil?
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def login_user!(user)
    session_token = user.reset_session_token!
    session[:session_token] = session_token
  end

  def signed_in?
    redirect_to cats_url if current_user
  end

  def confirm_owner
    redirect_to cats_url unless current_user.cats.any? { |cat| cat.id = params[:id] }
  end
end
