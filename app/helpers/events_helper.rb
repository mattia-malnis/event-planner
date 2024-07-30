module EventsHelper
  def temp_details(humidity, min, max)
    text = []
    text << "Temperature: #{min}°C to #{max}°C" if min.present? && max.present?
    text << "Humidity: #{humidity}%" if humidity.present?
    text.join(", ")
  end

  def date(event)
    return if event.blank?

    r = [ to_datetime(event.date_start), to_datetime(event.date_end) ]
    r.compact_blank.join ("<br>")
  end
end
