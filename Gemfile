source 'http://ruby.taobao.org'

gem 'rails', '3.2.13'
gem 'jquery-rails'
gem 'mongoid'
gem "slim-rails"
gem 'ipaddress'
gem 'settingslogic'
gem 'state_machine'

group :assets do
  gem 'therubyracer', :platforms => :ruby
  gem 'twitter-bootstrap-rails'
  gem 'uglifier', '>= 1.0.3'
end

group :test, :development do
  gem 'guard'
  gem 'rb-inotify', :require => false    # Guard needs this
  gem 'rb-fsevent', :require => false    # A Ruby wrapper for Linux's inotify, using FFI

  gem 'guard-bundler'
  gem 'guard-livereload'

  gem 'spork-rails'
  gem 'guard-spork'

  gem 'rspec-rails'
  gem 'guard-rspec'

  gem 'factory_girl_rails'
  gem 'database_cleaner'
end