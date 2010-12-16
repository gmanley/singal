require File.expand_path(File.dirname(__FILE__) + '/../../spec/spec_helper')

ENV['RACK_ENV'] ||= 'test'
Picawing.set(:environment, :test)

require 'capybara/cucumber'
Capybara.app = Picawing

module MyWorld
#  Capybara.javascript_driver = :envjs
  def app
    @app ||= Rack::BUilder.new do
      run Picawing
    end
  end
  include Rack::Test::Methods
end

World(MyWorld)
