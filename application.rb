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
  config = File.open(Pathname(Sinatra::Application.root)/"config/picasa.yml") { |file| YAML.load(file) }
  picasa = Picasa.new
  picasa.login(config['credentials']['email'], config['credentials']['password'])
  
  @images = Array.new
  doc = Nokogiri::XML(open("http://picasaweb.google.com/data/feed/api/user/#{picasa.user_id}/albumid/#{options.album_id}?kind=photo&access=public&thumbsize=#{config['options']['thumb_size']}&imgmax=#{config['options']['max_size']}", "Authorization" => "GoogleLogin auth=#{picasa.auth_key}", 'GData-Version' => '2'))  
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