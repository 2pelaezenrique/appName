json.array!(@classrooms) do |classroom|
  json.extract! classroom, :id, :name, :public, :password, :college
  json.url classroom_url(classroom, format: :json)
end
