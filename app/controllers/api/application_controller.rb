class Api::ApplicationController < ApplicationController

  # this skips using `authenticity_token` to prevent XSS attacks
  # We should make sure we have other measures of security within our API such as API keys
  skip_before_action :verify_authenticity_token

  private
  def authenticate_user!
    unless user_signed_in?
      render(json: { errors: ["Unauthorized"]}, status: 401 )
    end
  end
end
