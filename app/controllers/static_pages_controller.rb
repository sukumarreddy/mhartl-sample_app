class StaticPagesController < ApplicationController

  # Listing 3.6: no standard REST actions - because of 'rails generate' invocation?

  def home

    # Listing 10.34 (!) - n.b. ONLY signed in users can view microposts! (remember for testing)
    @micropost = current_user.microposts.build if signed_in?
  end

  def help
  end
  
  def about ; end # Listing 3.15

  def contact ; end # Listing 5.18
end
