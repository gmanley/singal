require 'rubygems'
require 'rake'
require 'sinatra'
require 'dm-core'
require 'dm-migrations'
require 'open-uri'
require 'nokogiri'

APPDIR = Sinatra::Application.root

namespace :log do
  desc "clear log files"
  task :clear do
    Dir[APPDIR + "log/*.log"].each do |log_file|
      f = File.open(log_file, "w")
      f.close
    end
  end
end

namespace :db do
  require APPDIR + "/models/photo"
  DataMapper::Logger.new(APPDIR + "/log/rake_db.log")
  DataMapper.setup(:default, ENV['DATABASE_URL'] || 'mysql://localhost/picasa_photos')

  desc "Migrate the database"
  task :migrate do
    Photo.auto_migrate!
  end
end

namespace :picasa do
  desc "Parse picasa photo feed."
  task :crawl do
    require APPDIR + "/lib/image_processor"
    ImageProcessor.new
  end
end