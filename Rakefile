require "rubygems"
require "bundler"
Bundler.setup

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
  desc "Migrate the database"
  task :migrate do
    require "lib/photo"
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