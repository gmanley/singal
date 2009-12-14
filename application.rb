require 'sinatra'
require 'open-uri'
require 'nokogiri'

# My Picasa details.
set :username, '' # Your Picasa username goes here.
set :album_id, '' # The album ID you want to display goes here.

# Thumbnail size. Can be 32, 48, 64, 72, 144, 160. cropt (c) and uncropt (u).
set :thumb_size, '160c'

# Maximum size. Can be 200, 288, 320, 400, 512, 576, 640, 720, 800.
set :max_size, '720u'

# Displays information on all albums.
get '/' do 
  @images = Array.new
  doc = Nokogiri::XML(open("http://picasaweb.google.com/data/feed/api/user/#{options.username}/albumid/#{options.album_id}?kind=photo&access=public&thumbsize=#{options.thumb_size}&imgmax=#{options.max_size}"))  
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
  
  erb :index
end