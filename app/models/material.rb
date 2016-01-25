class Material
  include Mongoid::Document
  include Mongoid::Paperclip

  has_mongoid_attached_file :file
  field :name, type: String
  field :description, type: String
  field :format, type: String
  field :uploadDate, type: Date
  field :type, type: String
  field :authors, type: Array
  field :searchable, type: Boolean
  field :tags, type: Array
  field :schools, type: Array
  field :subject, type: String
  field :updateDate, type: Date
  field :file_type, type: String

  #Youtube fields
  field :youtube_id, type: String
  field :video_duration, type: Integer
  field :thumbnail_url, type: String
  field :youtubeChannel_id, type: String
  field :youtubeChannel_avatar_url, type: String

  #Relations
  belongs_to :user
  embeds_many :comments
  embeds_many :favorites
end
