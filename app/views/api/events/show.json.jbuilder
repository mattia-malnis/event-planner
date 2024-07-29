json.data do
  json.extract! @event, :id, :title, :description, :date_start, :date_end, :lat, :long, :city
  json.country do
    json.extract! @event.country, :iso, :name
  end
end
