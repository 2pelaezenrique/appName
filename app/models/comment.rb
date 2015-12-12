class Comment
  include Mongoid::Document
  embedded_in :material, :inverse_of => :comments
end
