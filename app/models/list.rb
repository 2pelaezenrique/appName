class List
  include Mongoid::Document
  field :name, type: String
  field :description, type: String
  field :public, type: Mongoid::Boolean
end
