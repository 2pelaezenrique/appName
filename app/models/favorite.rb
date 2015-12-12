class Favorite
  include Mongoid::Document
  embedded_in :user, :inverse_of => :favorites
end
