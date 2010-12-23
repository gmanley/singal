source 'http://rubygems.org'

gem 'sinatra'

gem 'dm-core'
gem 'dm-timestamps'
gem 'dm-migrations'
gem 'dm-pager'
gem 'haml'
gem 'nokogiri'

group :production, :development do
  gem 'dm-mysql-adapter'
end

group :staging do
  gem 'dm-postgres-adapter'
end

group :development, :test do
  gem 'rack-test'
  gem 'rspec'
  gem 'redgreen'
  gem 'cucumber'
  gem 'capybara'
end