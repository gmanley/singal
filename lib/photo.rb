module Singal
  class Photo
    include Mongoid::Document
    store_in :photos

    field :image, :length => 150
    field :thumb, :length => 150
  end
end