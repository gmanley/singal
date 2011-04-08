source 'http://rubygems.org'

gem 'sinatra', :require => 'sinatra/base', :git => 'https://github.com/sinatra/sinatra.git', :ref => '447721528eedc9f47451'
gem 'mongoid', "~> 2.0"
gem 'bson_ext'
gem 'haml'
gem 'nokogiri'

group :production do
  gem 'passenger'
end

group :development do
  gem 'shotgun'
  gem 'thin'
end

group :development, :test do
  gem 'rack-test'
  gem 'yui-compressor'
end

group :test do
  gem 'rspec'
  gem 'cucumber'
  gem 'capybara'
end