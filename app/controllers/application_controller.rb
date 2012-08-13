class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end
  # Make the current user object available to views
  #----------------------------------------
  def get_user
    @current_user = current_user
  end
end
