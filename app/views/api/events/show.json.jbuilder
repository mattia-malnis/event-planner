json.data do
  json.extract! @event, :id, :title, :description, :country, :date, :lat, :long
end
