class Favorite
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :material
  belongs_to :user
end
