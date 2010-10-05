source 'http://rubygems.org'

gem 'sinatra', '>= 1.0'

gem 'dm-core', '>= 1.0.2'
gem 'dm-timestamps', '>= 1.0.2'
gem 'dm-migrations', '>= 1.0.2'
gem 'dm-pager', '>= 1.1.0'
gem 'haml', '>= 3.0.21'
gem 'nokogiri', '>= 1.4.3.1'

group :production, :development do
  gem 'dm-mysql-adapter', '>= 1.0.2'
end

group :staging do
  gem 'dm-postgres-adapter', '>= 1.0.2'
end

group :development, :test do
  gem 'rack-test', '>= 0.5.6'
  gem 'rspec', '>= 1.3.0'
  gem 'cucumber', '>= 0.9.1'
  gem 'cucumber-sinatra', '>= 0.2.4'
  gem 'capybara', '>= 0.3.9'
  gem 'redgreen', '>= 1.2.2'
end