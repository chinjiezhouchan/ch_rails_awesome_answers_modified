class SessionsController < ApplicationController
  def new
    # Nothing to pass. We are not creating a new instance of a session model to save in the database. 
    
    # Instead, we use the create action to only ask the database to compare the password data from a form submission to the database.
  end

  def create
    user = User.find_by_email params[:email]

    # .authenticate takes a password argument, then returns true or false.
    # It returns true if, after salting and hashing the password the same way it did so originally, the hash digest is the same as what's stored in the password_digest column in the users table.
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id

      flash[:success] = "Signed in!"
      redirect_to root_path
    else
      flash.now[:danger] = 'Wrong credentials!'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil

    flash[:success] = "Signed out!"
    redirect_to root_path
  end
end
