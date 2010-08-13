require 'rubygems'
require 'rake'
require 'sinatra'
require 'dm-core'
require 'dm-migrations'
require 'open-uri'
require 'nokogiri'

require Pathname(Sinatra::Application.root)/"lib"/"picasa"
require Pathname(Sinatra::Application.root)/"models"/"photo"
DataMapper::Logger.new(Pathname(Sinatra::Application.root)/"log"/"rake_db.log")
DataMapper.setup(:default, ENV['DATABASE_URL'] || 'mysql://localhost/picasa_photos')

namespace :log do
  desc "clear log files"
  task :clear do
    Dir.glob(File.join(File.dirname(__FILE__), 'log', '*.log')){ |file| File.open(file, "w") { |file| file << "" }}
  end
end

namespace :db do

  desc "Migrate the database"
  task :migrate do
    Photo.auto_migrate!
  end
end

namespace :picasa do

  desc "Parse picasa photo feed."
  task :parse do

    config = File.open(Pathname(Sinatra::Application.root)/"config/picasa.yml") { |file| YAML.load(file) }
    picasa = Picasa.new
    picasa.login(config['credentials']['email'], config['credentials']['password'])

    @albums = [] 

    albums = Nokogiri::XML(open("http://picasaweb.google.com/data/feed/api/user/#{picasa.user_id}?kind=album&access=private&fields=entry(gphoto:id)", "Authorization" => "GoogleLogin auth=#{picasa.auth_key}", 'GData-Version' => '2'))
    albums.xpath("//xmlns:entry//gphoto:id").each do |a|
      @albums << a.content
    end

    @images = []

    @albums.each do |album_id|
      config = File.open(Pathname(Sinatra::Application.root)/"config/picasa.yml") { |file| YAML.load(file) }
      doc = Nokogiri::XML(open("http://picasaweb.google.com/data/feed/api/user/#{picasa.user_id}/albumid/#{album_id}?kind=photo&thumbsize=#{config['options']['thumb_size']}&imgmax=#{config['options']['max_size']}&fields=entry(media:group(media:content,media:thumbnail))", "Authorization" => "GoogleLogin auth=#{picasa.auth_key}", 'GData-Version' => '2'))  
      doc.remove_namespaces!

      doc.xpath("//entry").each do |entry|
        entry.children.each do |n|
          if n.node_name == "group"

            image = Hash.new

            n.children.each do |g|
              case g.node_name
              when "content"
                image["image"] = g.attribute("url").content
              when "thumbnail"
                image["thumb"] =  g.attribute("url").content
              end
            end

            @images << image
          end
        end
      end
    end
    @images.each do |image|
      as = Photo.new
      as.attributes = image
      as.save
    end
  end
end