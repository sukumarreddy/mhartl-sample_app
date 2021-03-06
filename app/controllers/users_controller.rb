class UsersController < ApplicationController
  # Listing 9.12
  # Listing 9.22 - added :index
  # Listing 9.46 - added :delete. CRUD complete!
  # Listing 11.30 - added :following, :followers
  before_filter :signed_in_user, only: [:edit, :update, :index, :destroy, :following, :followers]

  # Listing 9.15
  before_filter :correct_user, only: [:edit, :update]

  # Listing 9.48
  before_filter :admin_user, only: :destroy

  def new
    redirect_to root_path if signed_in? # Exercise 9.6 (meh didn't bother writing a test)
  	@user = User.new # Listing 7.18
  end

  # Listing 7.5
  def show
  	@user = User.find params[:id]

    # Listing 10.22 - with will_paginate stupidity
    @microposts = @user.microposts.paginate(page: params[:page]) # paginate() works through the association

  end

  # Listing 7.21
  def create
    redirect_to root_path if signed_in? # Exercise 9.6
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

  # Listing 9.2
  def edit
    #@user = User.find params[:id] # made redundant by before_filter correct_user
  end

  # Listing 9.8
  def update
    #@user = User.find(params[:id]) # made redundant by before_filter correct_user
    if @user.update_attributes(params[:user])
      # Handle a successful update.
      # Listing 9.10
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  # Listing 9.22 - empty stub
  def index
    # Listing 9.24 - changed in Listing 9.35
    #@users = User.all

    # Listing 9.35
    @users = User.paginate(page: params[:page]) # will_paginate auto-generates both paginate() and params[:page]
  end

  # Listing 9.46
  def destroy
    
    # Exercise 9.9
    # User.find(params[:id]).destroy # note method chaining
    @user = User.find(params[:id])
    if current_user?(@user)
      flash[:error] = "Don't kill yourself you stupid admin"
      redirect_to root_url and return
    end
    @user.destroy    
    
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  # Listing 11.30
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow' # note explicit call to render() - share (NEARLY) identical view with followers()
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  # Listing 9.12 - moved to app/helpers/sessions_helper.rb in Listing 10.27
  private
  #def signed_in_user    
  #  unless signed_in?
  #    store_location # Listing 9.19 - stay on same page after signing in ("friendly forwarding")
  #    redirect_to signin_url, notice: "Please sign in." # shortcut for setting flash[:notice]
  #  end
  #end

  # Listing 9.15
  def correct_user
    @user = User.find params[:id]
    redirect_to(root_path) unless current_user?(@user)
  end

  # Listing 9.48
  def admin_user
    redirect_to root_path unless current_user.admin?
  end

end
