source 'http://rubygems.org'

gem 'sinatra', :require => 'sinatra/base', :git => 'git://github.com/sinatra/sinatra.git'
gem 'mongoid', :git => 'git://github.com/gmanley/mongoid.git', :branch => 'pagination'
gem 'bson_ext'
gem 'haml'
gem 'nokogiri'

group :production do
  gem 'passenger'
end

group :development do
  gem 'shotgun'
  gem 'thin'
  gem 'rack-test'
  gem 'yui-compressor'
end