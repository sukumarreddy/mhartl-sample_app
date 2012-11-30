class StaticPagesController < ApplicationController

  # Listing 3.6: no standard REST actions - because of 'rails generate' invocation?

  def home
  end

  def help
  end
  
  def about ; end # Listing 3.15

  def contact ; end # Listing 5.18
end
