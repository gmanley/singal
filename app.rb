require 'yaml'

module Picawing
  class App < Sinatra::Base

    set :root, File.dirname(__FILE__)

    def self.setup_db
      Mongoid.configure do |config|
        if ENV['MONGOHQ_URL'] # For heroku deploys
          conn = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
          config.master = conn.db(URI.parse(ENV['MONGOHQ_URL']).path.gsub(/^\//, ''))
        else
          # Refactor to use yaml file!
          config.from_hash(YAML.load_file('config/config.yml')["database"][settings.environment.to_s])
        end
      end
      require "#{settings.root}/lib/photo"
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