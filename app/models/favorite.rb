class Favorite
  include Mongoid::Document
  embedded_in :material, :inverse_of => :favorites
  field :user_id, type: String
end
