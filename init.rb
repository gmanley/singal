%w[
  rubygems
  bundler
  sinatra
  haml
  yaml
  dm-core
  dm-migrations
  dm-pager
  open-uri
  nokogiri
  logger
].each do |lib|
  begin
    require lib
  rescue LoadError => e
    puts "You need to install the #{lib} gem."
    exit(1)
  end
end

require "app"

APPENV = Picawing.environment
APPDIR = Picawing.root

Bundler.setup(:default, APPENV)

set :root,  APPDIR
set :app_file, File.join(APPDIR, 'app')
disable :run

FileUtils.mkdir_p File.join(APPDIR, 'log') unless File.exists?('log')
log = File.new(File.join(APPDIR, 'log', "#{APPENV}.log"), "a")
$stdout.reopen(log)
$stderr.reopen(log)

def setup_db(env)
  config = File.open(APPDIR + "/config/database.yml") { |file| YAML.load(file) }
  DataMapper::Logger.new(APPDIR + "/log/#{env}_db.log")
  DataMapper.setup(:default, ENV['DATABASE_URL'] || config[env.to_s])
end

configure(:production) do
  enable(:clean_trace)
  disable(:dump_errors)
  setup_db(:production)
end

configure(:development) do
  use Rack::Lint
  disable(:clean_trace)
  setup_db(:development)
end

configure do
  enable(:logging)
end

Dir[APPDIR/"lib"/'**'/'*.rb'].sort.each{|file| require file }