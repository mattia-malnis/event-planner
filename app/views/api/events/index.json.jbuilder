json.data do
  json.array! @events do |event|
    json.extract! event, :id, :title, :country, :date, :lat, :long
  end
end

json.metadata do
  json.extract! @pagination, :prev_url, :next_url, :count, :page, :prev, :next
end
