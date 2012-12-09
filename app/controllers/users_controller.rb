class UsersController < ApplicationController
  # Listing 9.12
  before_filter :signed_in_user, only: [:edit, :update]

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

  # Listing 9.2
  def edit
    @user = User.find params[:id]
  end

  # Listing 9.8
  def update
    @user = User.find(params[:id])
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

  # Listing 9.12
  private
  def signed_in_user
    redirect_to signin_url, notice: "Please sign in." unless signed_in? # shortcut for setting flash[:notice]
  end


end
