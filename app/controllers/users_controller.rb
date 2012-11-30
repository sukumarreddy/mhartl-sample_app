class UsersController < ApplicationController
  def new
  end

  # Listing 7.5
  def show
  	@user = User.find params[:id]
  end
end
