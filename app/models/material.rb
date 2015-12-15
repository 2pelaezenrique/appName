class Material
  include Mongoid::Document
  field :name, type: String
  field :description, type: String
  field :format, type: String
  # field :uploadDate, type: Date
  field :type, type: String
  # field :category, type: Hash
  field :link, type: String
  field :authors, type: Array
  field :youtubeChannel, type: String
  field :account, type: String

  field :tags, type: Array
  field :subject, type: String
  belongs_to :user
  embeds_many :comments
end
