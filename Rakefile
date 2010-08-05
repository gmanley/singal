require 'rubygems'
require 'rake'
require 'sinatra'
require 'dm-core'
require 'dm-migrations'
require 'open-uri'
require 'nokogiri'

require Pathname(Sinatra::Application.root)/"lib"/"picasa"
require Pathname(Sinatra::Application.root)/"models"/"photo"

namespace :log do
  desc "clear log files"
  task :clear do
    Dir.glob(File.join(File.dirname(__FILE__), 'log', '*.log')){ |file| File.open(file, "w") { |file| file << "" }}
  end
end

namespace :db do
  DataMapper::Logger.new(Pathname(Sinatra::Application.root)/"log"/"rake_db.log")
  DataMapper.setup(:default, 'mysql://localhost/picasa_photos')

  desc "Migrate the database"
  task :migrate do
    Photo.auto_migrate!
  end

  desc "Parse picasa photo feed."
  task :parse do

    config = File.open(Pathname(Sinatra::Application.root)/"config/picasa.yml") { |file| YAML.load(file) }
    picasa = Picasa.new
    picasa.login(config['credentials']['email'], config['credentials']['password'])

    @albums = [] 
    albums = Nokogiri::XML(open("http://picasaweb.google.com/data/feed/api/user/#{picasa.user_id}?kind=album&access=private", "Authorization" => "GoogleLogin auth=#{picasa.auth_key}", 'GData-Version' => '2'))
    albums.xpath("//xmlns:entry").each do |entry|

      album = Hash.new

      entry.children.each do |a|
        case "#{a.namespace.prefix}:#{a.node_name}"
        when ":title"
          album["title"] = a.content
        when "gphoto:id"
          album["id"] = a.content
        end
      end

      @albums << album
    end
    albums_id = @albums.map{|item| item.values_at("id")}.flatten

    @images = []

    albums_id.each do |album_id|
      config = File.open(Pathname(Sinatra::Application.root)/"config/picasa.yml") { |file| YAML.load(file) }
      doc = Nokogiri::XML(open("http://picasaweb.google.com/data/feed/api/user/#{picasa.user_id}/albumid/#{album_id}?kind=photo&thumbsize=#{config['options']['thumb_size']}&imgmax=#{config['options']['max_size']}", "Authorization" => "GoogleLogin auth=#{picasa.auth_key}", 'GData-Version' => '2'))  
      doc.remove_namespaces!

      doc.xpath("//entry").each do |entry|
        entry.children.each do |n|
          if n.node_name == "group"

            image = Hash.new

            n.children.each do |g|
              case g.node_name
              when "description"
                image["description"] = g.content
              when "content"
                image["content"] = g.attribute("url")
              when "thumbnail"
                image["thumbnail"] =  g.attribute("url")
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