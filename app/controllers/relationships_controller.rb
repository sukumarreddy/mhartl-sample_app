# Listing 11.34
class RelationshipsController < ApplicationController
  before_filter :signed_in_user # extra security (command-line create/destroy would hit nil current_user anyway)

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)

    # Listing 11.38
    #redirect_to @user
    respond_to do |format|
      format.html { redirect_to @user }
      format.js # Rails will automatically load the corresponding .js.erb file
    end

  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    
    # Listing 11.38
    #redirect_to @user
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end

  end
end