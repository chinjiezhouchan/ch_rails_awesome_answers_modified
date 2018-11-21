class Api::V1::SessionsController < Api::ApplicationController

  def create
    user = User.find_by_email params[:email]

    if user&.authenticate(params[:password])
      session[:user_id] = user.id

      # head :ok - In APIs, you should return JSON. Otherwise, the browser using JSON will think you returned an empty response that's just a header. 
      render json: { status: :success}
    else
      render json: { status: :error, message: "Wrong credentials" }
    end
  end

  def destroy
    session[:user_id] = nil
    head :success
  end
end
