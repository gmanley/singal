require "yaml"
require "logger"

APPENV = Picawing::App.environment
APPDIR = Picawing::App.root

def setup_logging
  enable(:logging)
  log = File.new(File.join(APPDIR, 'log', "#{APPENV}.log"), "a")
  $stdout.reopen(log)
  $stderr.reopen(log)
end

def setup_db
  DataMapper::Logger.new(File.join(APPDIR, "/log/#{APPENV}_db.log"))
  DataMapper.setup(:default, ENV['DATABASE_URL'] || 'mysql://localhost/picasa_photos')
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