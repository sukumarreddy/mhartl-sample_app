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
  	  # Handle a successful save
  	  redirect_to @user # Listing 7.25 - see also Exercises...
  	else
  	  render 'new'
  	end
  end

end
