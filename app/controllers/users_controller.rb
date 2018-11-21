class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    
    respond_to do |format|
      format.html do
        if @user.save
          session[:user_id] = @user.id
          flash[:success] = 'Thank you for signing up!'
          redirect_to root_path
        else
          render :new
        end
      end

      format.json do
        if @user.save
          session[:user_id] = @user.id
          render json: { status: :ok }
        else
          render(
            json: { status: 422, errors: @user.errors.messages },
            status: 422
          )
        end
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name,
                                 :last_name,
                                 :email,
                                 :password,
                                 :password_confirmation)
  end
end
