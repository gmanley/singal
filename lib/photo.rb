require 'dm-core'
require 'dm-timestamps'
require 'dm-migrations'

class Photo
  include DataMapper::Resource

  property :id, Serial
  property :image, String, :length => 200
  property :thumb,   String, :length => 200
  property :created_at, DateTime

end