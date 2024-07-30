json.data do
  json.extract! @event, :id, :title, :description, :date_start, :date_end, :lat, :long, :city
  json.image_url @event.image.attached? ? url_for(@event.image) : nil
  json.country do
    json.extract! @event.country, :iso, :name
  end
end
