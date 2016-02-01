class List
	include Mongoid::Document
	include Mongoid::Timestamps
	belongs_to :user
	field :name, type: String
	field :description, type: String
	field :public, type: Mongoid::Boolean
	field :materials, type: Array, default: []
end
