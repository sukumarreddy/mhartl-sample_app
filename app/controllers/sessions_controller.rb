class SessionsController < ApplicationController

  # Listing 8.3 - empty new, create, destroy functions
  def new; end

  def create 

    # Listing 8.10 failed signin
    user = User.find_by_email params[:session][:email].downcase # because db saves as lowercase
    if user && user.authenticate(params[:session][:password]) # uh, why does this need parens? meh
      # Sign the user in and redirect to user's show page
    else

      # Listing 8.12 magical flash.now instead of flash
      #flash[:error] = 'Invalid email/password combination' # "Not quite right"
      flash.now[:error] = 'Invalid email/password combination'
      
      # Listing 8.9 preliminary
      render 'new'  
    end

    
  end
  
  def destroy; end
end
