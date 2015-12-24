class Material
  include Mongoid::Document
  include Mongoid::Paperclip

  has_mongoid_attached_file :file
  field :name, type: String
  field :description, type: String
  field :format, type: String
  field :uploadDate, type: Date
  field :type, type: String
  # field :category, type: Hash
  field :link, type: String
  field :authors, type: Array
  field :youtubeChannel, type: String
  field :searchable, type: Boolean
  field :tags, type: Array
  field :schools, type: Array
  field :subject, type: String
  field :username, type: String
  field :updateDate, type: Date
  belongs_to :user
  embeds_many :comments
end
