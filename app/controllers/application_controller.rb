class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_filter :store_location
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token 

  Yt.configuration.api_key = ENV["YOUTUBE_API_KEY"]
  Yt.configure do |config| 
    config.log_level = :debug 
  end
  private
  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    return unless request.get? 
    if (request.path != "/users/sign_in" &&
        request.path != "/users/sign_up" &&
        request.path != "/users/password/new" &&
        request.path != "/users/password/edit" &&
        request.path != "/users/confirmation" &&
        request.path != "/users/sign_out" &&
        request.path != "/bye" &&
        request.env["HTTP_X_REQUESTED_WITH"] != "XMLHttpRequest" &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath 
    end
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end
  def after_sign_out_path_for(resource)
    bye_path
  end
  def after_update_path_for(resource)
    session[:previous_url] || root_path
  end
  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
end
