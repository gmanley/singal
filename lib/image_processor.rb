require 'open-uri'
require 'nokogiri'
require 'mongoid'
require "yaml"
require "lib/picasa"

module Picawing
  class ImageProcessor

    def initialize
      # TODO: Refactor app config in general... maybe an config class?
      file = File.dirname(__FILE__) + "/../config/config.yml"
      begin
        @config = File.open(File.dirname(__FILE__) + "/../config/config.yml") { |file| YAML.load(file) }["picasa"]
      rescue Exception => e
        puts <<-EOS
Heroku deploy detected!
You need set the following config variables like so:
  `heroku config:add picasa_email=email`
  `heroku config:add picasa_password=password`
  `heroku config:add picasa_max_size=size`
  `heroku config:add picasa_thumb_size=size`
EOS

        @config = {"credentials" => {"email" => ENV["picasa_email"], "password" => ENV["picasa_password"]},
        "options" => {"max_size" => ENV["picasa_max_size"], "thumb_size" =>  ENV["picasa_thumb_size"]}}
      end

      @picasa = Picasa.new
      @picasa.login(@config['credentials']['email'], @config['credentials']['password'])
      import
    end

    def import
      find_albums
      process_albums
      process_images
      cache_image_urls
    end

    def find_albums
      puts "Finding albums to import."
      @albums = []
      albums = Nokogiri::XML(open("http://picasaweb.google.com/data/feed/api/user/#{@picasa.user_id}?kind=album&access=private&fields=entry(gphoto:id)", "Authorization" => "GoogleLogin auth=#{@picasa.auth_key}", 'GData-Version' => '2'))
      albums.xpath("//xmlns:entry//gphoto:id").each do |a|
        @albums << a.content
      end
    end

    def process_albums
      puts "Processing albums."
      @image_groups = []
      @albums.each do |album_id|
        doc = Nokogiri::XML(open("http://picasaweb.google.com/data/feed/api/user/#{@picasa.user_id}/albumid/#{album_id}?kind=photo&thumbsize=#{@config['options']['thumb_size']}&imgmax=#{@config['options']['max_size']}&fields=entry(media:group(media:content,media:thumbnail))", "Authorization" => "GoogleLogin auth=#{@picasa.auth_key}", 'GData-Version' => '2'))
        doc.remove_namespaces!

        doc.xpath("//entry").each do |entry|
          entry.children.each do |n|
            if n.node_name == "group"
              @image_groups << n
            end
          end
        end
      end
    end

    def process_images
      puts "Processing images."
      @images = []
      @image_groups.each do |image_group|
        image = {}
        image_group.children.each do |g|
          case g.node_name
          when "content"
            image["image"] = g.attribute("url").content
          when "thumbnail"
            image["thumb"] = g.attribute("url").content
          end
        end

        @images << image
      end
    end

    def cache_image_urls
      puts "Caching images to database."
      Mongoid.configure do |config|
        if ENV['MONGOHQ_URL'] # For heroku deploys
          conn = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
          config.master = conn.db(URI.parse(ENV['MONGOHQ_URL']).path.gsub(/^\//, ''))
        else
          config.from_hash(YAML.load_file('config/config.yml')["database"][ENV["RACK_ENV"]])
        end
      end
      require File.dirname(__FILE__) + "/photo"
      @images.each do |image|
        Photo.create(:image => image['image'], :thumb => image['thumb'])
      end
    end
  end
end