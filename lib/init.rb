require "yaml"
require "logger"

APPENV = Picawing::App.environment
APPDIR = Picawing::App.root

require 'pagination_helper'

def setup_logging
  enable(:logging)
  log = File.new(File.join(APPDIR, 'log', "#{APPENV}.log"), "a")
  $stdout.reopen(log)
  $stderr.reopen(log)
end

def setup_db
  Mongoid.configure do |config|
    if ENV['MONGOHQ_URL']
      conn = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
      uri = URI.parse(ENV['MONGOHQ_URL'])
      config.master = conn.db(uri.path.gsub(/^\//, ''))
    else
      # Refactor to use yaml file!
      config.master = Mongo::Connection.from_uri("mongodb://localhost:27017").db("picawing")
    end
  end
  require "#{APPDIR}/lib/photo"
end

configure(:production) do
  enable(:clean_trace)
  disable(:dump_errors)
end

configure(:development) do
  use Rack::Lint
  disable(:clean_trace)
end

configure do
  disable :run
  setup_logging
  setup_db
end