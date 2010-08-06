%w[
  rubygems
  sinatra
  haml
  yaml
  dm-core
  dm-migrations
  dm-pager
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

  unless defined?(APPDIR)
    APPDIR = Pathname(Sinatra::Application.root)
  end

  def setup_db(env)
    config = File.open(APPDIR/"config"/"database.yml") { |file| YAML.load(file) }
    DataMapper::Logger.new(APPDIR/"log"/"#{env}_db.log")
    DataMapper.setup(:default, config[env.to_s])
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
    @photos = Photo.page(params["page"], :per_page => 50)
    haml :index
  end

  get '/slideshow' do
    haml :'slideshow/index', {:layout => :"slideshow/layout"}
  end

  get '/:user_id/:album_id' do
    config = File.open(APPDIR + "config/picasa.yml") { |file| YAML.load(file) }
    @images = [] 
    doc = Nokogiri::XML(open("http://picasaweb.google.com/data/feed/api/user/#{params[:user_id]}/albumid/#{params[:album_id]}?kind=photo&thumbsize=#{config['options']['thumb_size']}&imgmax=#{config['options']['max_size']}", 'GData-Version' => '2'))
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

    haml :album
  end