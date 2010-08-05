%w[
  rubygems
  sinatra
  erb
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

  configure(:production) do
    enable(:clean_trace)
    disable(:dump_errors)
  end

  configure(:development) do
    use Rack::Lint
    disable(:clean_trace)
  end

  configure do
    enable(:logging)
  end

  # Extra Local Requires
  #---------------------------
  require APPDIR + "lib/picasa"

  get '/' do
    config = File.open(APPDIR + "config/picasa.yml") { |file| YAML.load(file) }
    picasa = Picasa.new
    picasa.login(config['credentials']['email'], config['credentials']['password'])

    @albums = []
    albums = Nokogiri::XML(open("http://picasaweb.google.com/data/feed/api/user/#{picasa.user_id}?kind=album&access=private", "Authorization" => "GoogleLogin auth=#{picasa.auth_key}", 'GData-Version' => '2'))
    albums.xpath("//xmlns:entry").each do |entry|

      album = {}

      entry.children.each do |a|
        case "#{a.namespace.prefix}:#{a.node_name}"
        when ":title"
          album["title"] = a.content
        when "gphoto:id"
          album["id"] = a.content
        end
      end
      @albums << album
    end
    albums_id = @albums.map{|item| item.values_at("id")}.flatten

    @images = []
    albums_id.each do |album_id|
      config = File.open(APPDIR + "config/picasa.yml") { |file| YAML.load(file) }
      doc = Nokogiri::XML(open("http://picasaweb.google.com/data/feed/api/user/#{picasa.user_id}/albumid/#{album_id}?kind=photo&thumbsize=#{config['options']['thumb_size']}&imgmax=#{config['options']['max_size']}", "Authorization" => "GoogleLogin auth=#{picasa.auth_key}", 'GData-Version' => '2'))  
      doc.remove_namespaces!

      doc.xpath("//entry").each do |entry|
        entry.children.each do |n|
          if n.node_name == "group"

            image = {}

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
    end

    erb :index
  end

  get '/album/:album_id' do
    config = File.open(APPDIR + "config/picasa.yml") { |file| YAML.load(file) }
    picasa = Picasa.new
    picasa.login(config['credentials']['email'], config['credentials']['password'])

    @images = [] 
    doc = Nokogiri::XML(open("http://picasaweb.google.com/data/feed/api/user/#{picasa.user_id}/albumid/#{params[:album_id]}?kind=photo&thumbsize=#{config['options']['thumb_size']}&imgmax=#{config['options']['max_size']}", "Authorization" => "GoogleLogin auth=#{picasa.auth_key}", 'GData-Version' => '2'))
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