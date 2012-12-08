class ApplicationController < ActionController::Base
  protect_from_forgery

  # Listing 8.14 site-wide sign-in (by default, helpers are unavailable in controllers)
  include SessionsHelper

end
