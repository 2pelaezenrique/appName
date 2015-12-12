class Classroom
  include Mongoid::Document
  field :name, type: String
  field :public, type: Mongoid::Boolean
  field :password, type: String
  field :college, type: String
  has_and_belongs_to_many :users
end
