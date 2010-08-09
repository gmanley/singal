%w[
  rubygems
  sinatra
  haml
  yaml
  dm-core
  dm-migrations
  dm-pager
  dm-serializer/to_json
  open-uri
  nokogiri
  pathname
  logger
  ].each do |lib|
    begin
      require lib
    rescue LoadError => e
      puts "You need to install the #{lib} gem."
      exit(1)
    end
  end
  
  #mime_type :json, "application/json"

  unless defined?(APPDIR)
    APPDIR = Pathname(Sinatra::Application.root)
  end

  def setup_db(env)
    config = File.open(APPDIR/"config"/"database.yml") { |file| YAML.load(file) }
    DataMapper::Logger.new(APPDIR/"log"/"#{env}_db.log")
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
  require APPDIR + "lib/picasa"
  require APPDIR + "models/photo"

  get '/' do
    @photos = Photo.page(params["page"], :per_page => 100)
    haml :index
  end

  get '/slideshow' do
    haml :'slideshow/index', {:layout => :"slideshow/layout"}
  end
  
  get '/slideshow.json' do
    content_type :json
    Photo.all.to_json
  end

  error OpenURI::HTTPError do
    'Can not find specified album id or user. Please make sure they are correct.'
  end

  get '/album/:user_id/:album_id' do
    config = File.open(APPDIR + "config/picasa.yml") { |file| YAML.load(file) }
    @images = [] 
    doc = Nokogiri::XML(open("http://picasaweb.google.com/data/feed/api/user/#{params[:user_id]}/albumid/#{params[:album_id]}?kind=photo&thumbsize=#{config['options']['thumb_size']}&imgmax=#{config['options']['max_size']}&fields=entry(media:group(media:content,media:thumbnail)", 'GData-Version' => '2'))
    doc.remove_namespaces!
    image = Hash.new
    doc.xpath("//entry/group").children.each do |g|
      case g.node_name
      when "content"
        image["image"] = g.attribute("url").content
      when "thumbnail"
        image["thumb"] =  g.attribute("url").content
      end
      @images << image
    end

    haml :album
  end