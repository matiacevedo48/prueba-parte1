class ApplicationController < ActionController::Base
    before_action :configure_permited_parameters, if: :devise_controller?

    protected
    def configure_permited_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :photo_url])
        devise_parameter_sanitizer.permit(:account_update, keys: [:username, :photo_url])
    end
end
