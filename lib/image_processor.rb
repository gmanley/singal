class ImageProcessor

  def initialize
    @config = File.open(Pathname(Sinatra::Application.root)/"config/picasa.yml") { |file| YAML.load(file) }
    picasa = Picasa.new
    picasa.login(@config['credentials']['email'], @config['credentials']['password'])
  end

  def run
    collect_albums
    process_albums
    cache_images
  end

  def collect_albums
    @albums = []

    albums = Nokogiri::XML(open("http://picasaweb.google.com/data/feed/api/user/#{picasa.user_id}?kind=album&access=private&fields=entry(gphoto:id)", "Authorization" => "GoogleLogin auth=#{picasa.auth_key}", 'GData-Version' => '2'))
    albums.xpath("//xmlns:entry//gphoto:id").each do |a|
      @albums << a.content
    end
    @albums
  end

  def process_images
    @images = []

    @albums.each do |album_id|
      doc = Nokogiri::XML(open("http://picasaweb.google.com/data/feed/api/user/#{picasa.user_id}/albumid/#{album_id}?kind=photo&thumbsize=#{@config['options']['thumb_size']}&imgmax=#{@config['options']['max_size']}&fields=entry(media:group(media:content,media:thumbnail))", "Authorization" => "GoogleLogin auth=#{picasa.auth_key}", 'GData-Version' => '2'))
      doc.remove_namespaces!

      doc.xpath("//entry").each do |entry|
        entry.children.each do |n|
          if n.node_name == "group"

            image = Hash.new

            n.children.each do |g|
              case g.node_name
              when "content"
                image["image"] = g.attribute("url").content
              when "thumbnail"
                image["thumb"] = g.attribute("url").content
              end
            end

            @images << image
          end
        end
      end
    end
  end

  def cache_images
    @images.each do |image|
      as = Photo.new
      as.attributes = image
      as.save
    end
  end
end