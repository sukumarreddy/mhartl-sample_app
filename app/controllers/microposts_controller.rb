# Listing 10.28
class MicropostsController < ApplicationController
  before_filter :signed_in_user

  def create
    # Listing 10.30
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end

  def destroy
  end
end
