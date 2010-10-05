%w[
  haml
  yaml
  dm-core
  dm-migrations
  dm-pager
  open-uri
  nokogiri
  logger
  ].each do |lib|
    begin
      require lib
    rescue LoadError => e
      puts "You need to install the #{lib} gem."
      exit(1)
    end
  end

  unless defined?(APPDIR)
    #Application.root doesn't seem to work in 1.9
    #APPDIR = Pathname(Sinatra::Application.root)
    APPDIR = File.dirname(__FILE__)
  end

  def setup_db(env)
    config = File.open(APPDIR + "/config/database.yml") { |file| YAML.load(file) }
    DataMapper::Logger.new(APPDIR + "/log/#{env}_db.log")
    DataMapper.setup(:default, ENV['DATABASE_URL'] || config[env.to_s])
  end

  configure(:production) do
    enable(:clean_trace)
    disable(:dump_errors)
    setup_db(:production)
  end

  configure(:development) do
    use Rack::Lint
    disable(:clean_trace)
    setup_db(:development)
  end

  configure do
    enable(:logging)
  end

  # Extra Local Requires
  #---------------------------
  require APPDIR + "/lib/picasa"
  require APPDIR + "/models/photo"

  get '/' do
    @photos = Photo.page(params["page"], :per_page => 100)
    haml :index
  end

  get '/bot' do
    status 403
    haml :bot
  end