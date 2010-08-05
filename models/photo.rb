require 'dm-timestamps'

class Photo
  include DataMapper::Resource

  property :id, Serial
  property :description,  String, :length => 250
  property :content, String, :length => 200
  property :thumbnail,   String, :length => 200
  property :created_at, DateTime

end