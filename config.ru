require "rubygems"
require "sinatra/base"

require "bundler/setup"
Bundler.require(:default, ENV["RACK_ENV"])

require "app"
run Picawing::App