class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  field :body, type: String
  field :user_id, type: String
  embedded_in :material, :inverse_of => :comments
end
