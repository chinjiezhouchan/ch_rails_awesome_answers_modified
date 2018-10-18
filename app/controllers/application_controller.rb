class ApplicationController < ActionController::Base

  def current_user
    @current_user ||= User.find(session[:user_id])
  end
  helper_method :current_user
  # by addinng the `helper_method` above 👆, we make this method available in
  # the view files. Normally, it's only available in controllers.

end
