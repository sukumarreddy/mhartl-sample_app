class UsersController < ApplicationController
  def new
  	@user = User.new # Listing 7.18
  end

  # Listing 7.5
  def show
  	@user = User.find params[:id]
  end

  # Listing 7.21
  def create
  	@user = User.new params[:user]
  	if @user.save
      sign_in @user # Listing 8.27
  	  # Handle a successful save
      flash[:success] = "Welcome to the Sample App!" # Listing 7.27
  	  redirect_to @user # Listing 7.25 - see also Exercises...
  	else
  	  render 'new'
  	end
  end

end
