class Picawing < Sinatra::Application

  get '/' do
    @photos = Photo.page(params["page"], :per_page => 100)
    haml :index
  end

  get '/bot' do
    status 403
    haml :bot
  end

end