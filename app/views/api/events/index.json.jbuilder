json.data do
  json.array! @events do |event|
    json.extract! event, :id, :title, :description, :date_start, :date_end, :lat, :long, :city
    json.country do
      json.extract! event.country, :iso, :name
    end
  end
end

json.metadata do
  json.extract! @pagination, :prev_url, :next_url, :count, :page, :prev, :next
end
