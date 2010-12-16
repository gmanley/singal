class ImageProcessor

  def initialize
    @config = File.open(APPDIR + "/config/picasa.yml") { |file| YAML.load(file) }
    @picasa = Picasa.new
    @picasa.login(@config['credentials']['email'], @config['credentials']['password'])
    run
  end

  def cache?
    @config['options']['cache']
  end

  def run
    find_albums
    process_albums
    process_images
    cache_image_urls if cache?
  end

  def find_albums
    @albums = []
    albums = Nokogiri::XML(open("http://picasaweb.google.com/data/feed/api/user/#{@picasa.user_id}?kind=album&access=private&fields=entry(gphoto:id)", "Authorization" => "GoogleLogin auth=#{@picasa.auth_key}", 'GData-Version' => '2'))
    albums.xpath("//xmlns:entry//gphoto:id").each do |a|
      @albums << a.content
    end
  end

  def process_albums
    @image_groups = []
    @albums.each do |album_id|
      doc = Nokogiri::XML(open("http://picasaweb.google.com/data/feed/api/user/#{@picasa.user_id}/albumid/#{album_id}?kind=photo&thumbsize=#{@config['options']['thumb_size']}&imgmax=#{@config['options']['max_size']}&fields=entry(media:group(media:content,media:thumbnail))", "Authorization" => "GoogleLogin auth=#{@picasa.auth_key}", 'GData-Version' => '2'))
      doc.remove_namespaces!

      doc.xpath("//entry").each do |entry|
        entry.children.each do |n|
          if n.node_name == "group"
            @image_groups << n
          end
        end
      end
    end
  end

  def process_images
    @images = []
    image = {}
    @image_groups.each do |image_group|
      image_group.children.each do |g|
        case g.node_name
        when "content"
          image["image"] = g.attribute("url").content
        when "thumbnail"
          image["thumb"] = g.attribute("url").content
        end
        @images << image
      end
    end
  end

  def cache_image_urls
    @images.each do |image|
      as = Photo.new
      as.attributes = image
      as.save
    end
  end
end