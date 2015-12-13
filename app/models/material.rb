class Material
  include Mongoid::Document
  field :name, type: String
  field :description, type: String
  # field :uploadDate, type: Date
  field :type, type: String
  # field :category, type: Hash
  field :format, type: String
  belongs_to :user
  embeds_many :comments
end
