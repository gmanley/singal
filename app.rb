require 'yaml'

module Singal
  class App < Sinatra::Base

    def self.setup_db
      Mongoid.configure do |config|
        if mongodb_url = (ENV['MONGOHQ_URL'] || ENV['MONGOLAB_URI']) # For heroku deploys
          conn = Mongo::Connection.from_uri(mongodb_url)
          config.master = conn.db(URI.parse(mongodb_url).path.gsub(/^\//, ''))
        else
          config.from_hash(YAML.load_file('config/config.yml')["database"][settings.environment.to_s])
        end
      end
      require "lib/photo"
    end

    configure(:production, :development) do
      enable(:logging, :dump_errors)
    end

    configure do
      setup_db
    end

    require "lib/pagination_helper"
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