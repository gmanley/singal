require 'rubygems'
require 'bundler'
require 'sinatra'

APPENV = Sinatra::Application.environment
APPDIR = Sinatra::Application.root

Bundler.setup(:default, APPENV)
require APPDIR + "/application"

set :root,  APPDIR
set :app_file, File.join(APPDIR, 'application.rb')
disable :run

FileUtils.mkdir_p File.join(APPDIR, 'log') unless File.exists?('log')
log = File.new(File.join(APPDIR, 'log', "#{APPENV}.log"), "a")
$stdout.reopen(log)
$stderr.reopen(log)

run Sinatra::Application