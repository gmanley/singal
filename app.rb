module Picawing
  class App < Sinatra::Base

    set :root, File.dirname(__FILE__)
    require "lib/init"

    helpers WillPaginate::ViewHelpers::Base

    get '/' do
      @photos = Photo.paginate(:page => 1, :per_page => 100)
      haml :index, :format => :html5
    end

    get '/page/:page_number' do |page_number|
      @photos = Photo.paginate(:page => page_number, :per_page => 100)
      haml :index, :format => :html5
    end
  end
end