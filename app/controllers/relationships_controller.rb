# Listing 11.34
class RelationshipsController < ApplicationController
  before_filter :signed_in_user # extra security (command-line create/destroy would hit nil current_user anyway)

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    redirect_to @user
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    redirect_to @user
  end
end