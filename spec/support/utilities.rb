# Listing 5.26 (requires restarting Guard)
#def full_title(page_title)
#  base_title = "Ruby on Rails Tutorial Sample App"
#  if page_title.empty?
#    base_title
#  else
#    "#{base_title} | #{page_title}"
#  end
#end

# Listing 5.38 - reaches back into app/helpers (searches by class name, I guess?)
include ApplicationHelper

# Listing 8.34
def valid_signin(user)
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: message)
  end
end

# Listing 9.6
def sign_in(user)
  visit signin_path
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"

  # Sign in when not using Capybara as well. [see Listing 9.47?]
  cookies[:remember_token] = user.remember_token
end
