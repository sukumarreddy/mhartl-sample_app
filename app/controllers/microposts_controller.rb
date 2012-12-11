# Listing 10.28
class MicropostsController < ApplicationController
  # Listing 10.49 added "only: [:create, :destroy]"
  before_filter :signed_in_user, only: [:create, :destroy]

  # Listing 10.49
  before_filter :correct_user, only: :destroy

  def create
    # Listing 10.30
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      # Listing 10.45 for broken tests (failed micropost submission)
      @feed_items = []

      render 'static_pages/home'
    end
  end

  def destroy
    # Listing 10.49
    @micropost.destroy
    redirect_to root_url
  end

  ############
  private

  # Listing 10.49
  def correct_user
    @micropost = current_user.microposts.find_by_id(params[:id])
    redirect_to root_url if @micropost.nil?
  end


end
