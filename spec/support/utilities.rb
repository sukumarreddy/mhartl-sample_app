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
