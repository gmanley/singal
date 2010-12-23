module Picawing
    class App < Sinatra::Base
    
    set :root, File.dirname(__FILE__)
    require "lib/init"

    get '/' do
      @photos = Photo.page(params["page"], :per_page => 100)
      haml :index
    end

  end
end