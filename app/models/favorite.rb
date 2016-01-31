class Favorite
  include Mongoid::Document
  include Mongoid::Timestamps
  embedded_in :material, :inverse_of => :favorites
  field :user_id, type: String
end
