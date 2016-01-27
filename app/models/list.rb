class List
  include Mongoid::Document
  include Mongoid::Timestamps
  has_many :materials
  field :name, type: String
  field :description, type: String
  field :public, type: Mongoid::Boolean
end
