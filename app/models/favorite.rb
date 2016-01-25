class Favorite
  include Mongoid::Document
  embedded_in :material, :inverse_of => :favorites
  belongs_to :user
end
