module EventsHelper
  def temp_details(humidity, min, max)
    text = []
    text << "Temperature: #{min}°C to #{max}°C" if min.present? && max.present?
    text << "Humidity: #{humidity}%" if humidity.present?
    text.join(", ")
  end
end
