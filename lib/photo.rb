class Photo
  include Mongoid::Document

  field :image, :length => 150
  field :thumb, :length => 150

end