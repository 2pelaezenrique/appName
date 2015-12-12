json.array!(@materials) do |material|
  json.extract! material, :id, :name, :description, :uploadDate, :type, :category, :format
  json.url material_url(material, format: :json)
end
