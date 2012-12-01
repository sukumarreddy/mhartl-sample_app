class UsersController < ApplicationController
  def new
  	@user = User.new # Listing 7.18
  end

  # Listing 7.5
  def show
  	@user = User.find params[:id]
  end
end
