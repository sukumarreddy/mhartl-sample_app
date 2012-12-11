# Listing 11.34
class RelationshipsController < ApplicationController
  before_filter :signed_in_user # extra security (command-line create/destroy would hit nil current_user anyway)

  # Listing 11.47 (Exercise 11.2)
  respond_to :html, :js

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)

    # Listing 11.47 (Exercise 11.2) - see also respond_to(), inside class definition
    ## Listing 11.38
    ##redirect_to @user
    #respond_to do |format|
    #  format.html { redirect_to @user }
    #  format.js # Rails will automatically load the corresponding .js.erb file
    #end
    respond_with @user

  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    
    # Listing 11.47 (Exercise 11.2)
    ## Listing 11.38
    ##redirect_to @user
    #respond_to do |format|
    #  format.html { redirect_to @user }
    #  format.js
    #end
    respond_with @user

  end
end