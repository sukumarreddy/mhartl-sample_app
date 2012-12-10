module SessionsHelper

  # Listing 8.19 "complete (but not-yet-working) sign_in function"
  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token # really expires in 20 years
    self.current_user = user
  end

  # Listing 8.23 - in preparation for view
  def signed_in?
    !current_user.nil?
  end

  # Listing 8.30 - by symmetry with sign_in
  def sign_out
    self.current_user = nil
    cookies.delete :remember_token
  end

  # Listing 8.20 current_user wasn't even defined. did that really merit a section break??
  def current_user=(user)
    @current_user = user
  end

  # Listing 8.22 - need to REMEMBER user! can't just use attr_accessor
  def current_user
    @current_user ||= User.find_by_remember_token cookies[:remember_token]
  end

  # Listing 9.16
  def current_user?(user)
    user == current_user
  end

  # Listing 9.18
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to) # Rails' cookie API (auto-expires on browser close)
  end

  def store_location
    session[:return_to] = request.url # access raw HTTP request object
  end

  # Listing 10.27 - moved from UserController
  def signed_in_user    
    unless signed_in?
      store_location # Listing 9.19 - stay on same page after signing in ("friendly forwarding")
      redirect_to signin_url, notice: "Please sign in." # shortcut for setting flash[:notice]
    end
  end

end
