source 'https://rubygems.org'

# Listing 3.1 version freeze
gem 'rails', '3.2.9'

# Listing 5.3
gem 'bootstrap-sass', '2.1'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :development, :test do
  gem 'sqlite3', '1.3.5'
  gem 'rspec-rails', '2.11.0'
  gem 'guard-rspec', '1.2.1' # Listing 3.33 - this doesn't work with VMware shared folders...
  
  # CS169.1x autotest
  # ugh this doesn't watch view files? ignore for now...? http://zentest.rubyforge.org/ZenTest/
  gem 'ZenTest'
  
  # http://stackoverflow.com/questions/3622193/autotest-on-ubuntu-does-nothing
  # no different from ZenTest?
  #gem 'autotest'
  #gem 'autotest-rails'
  
  # Listing 3.35
  gem 'guard-spork', '1.2.0'
  gem 'spork', '0.9.2'
end


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '3.2.5'
  gem 'coffee-rails', '3.2.2'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '1.2.3'
end

gem 'jquery-rails', '2.0.2'

group :test do
  gem 'capybara', '1.1.2'
  
  # Listing 3.33 Test gems on Linux
  gem 'rb-inotify', '0.8.8'
  gem 'libnotify', '0.5.9'
end

group :production do
  gem 'pg', '0.12.2'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
