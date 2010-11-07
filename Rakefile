require 'rubygems'
require 'rake'

namespace :log do
  desc "clear log files"
  task :clear do
    Dir["log/*.log"].each do |log_file|
      f = File.open(log_file, "w")
      f.close
    end
  end
end

namespace :db do
  require "dm-core"
  require "dm-migrations"
  require "lib/photo"
  DataMapper::Logger.new("log/rake_db.log")
  DataMapper.setup(:default, ENV['DATABASE_URL'] || 'mysql://localhost/picasa_photos')

  desc "Migrate the database"
  task :migrate do
    Photo.auto_migrate!
  end
end

namespace :picasa do
  desc "Parse picasa photo feed."
  task :crawl do
    require "lib/image_processor"
    ImageProcessor.new
  end
end