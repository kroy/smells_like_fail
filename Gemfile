source 'https://rubygems.org'

gem 'rails', '3.2.12'
# bootstrap occassionally causes problems with heroku
gem 'bootstrap-sass', '~> 2.3.0.0'
gem 'bootstrap-will_paginate'
gem 'json'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'
group :development, :test do
	#gem 'sqlite3', '1.3.5'
	gem 'pg','0.12.2'
	gem 'rspec-rails', '2.11.0'
	gem 'guard-rspec', '1.2.1'
end

group :production do
	gem 'pg','0.12.2'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '3.2.5'
  gem 'coffee-rails', '3.2.2'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '1.2.3'
end

group :development do
	gem 'annotate','2.5.0'
end

group :test do
	gem 'capybara', '1.1.2'
	gem 'rb-fchange', '0.0.5'
	gem 'rb-notifu', '0.0.4'
	gem 'win32console','1.3.0'
end

gem 'jquery-rails'#, '2.0.2'

#@TODO make this legit.  Find out why my js runtime isn't working
# check for updates to libv8 to fix install issues
#gem 'therubyracer'
#gem 'libv8', '3.11.8.0'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
