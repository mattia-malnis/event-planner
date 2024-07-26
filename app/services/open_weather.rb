# https://openweathermap.org/api/one-call-3#current
# Use OpenWeather APIs to get essential weather data and forecasts

require "net/http"
require "json"

class OpenWeather
  BASE_URL = "https://api.openweathermap.org/data/3.0/onecall".freeze
  ICON_BASE_URL = "https://openweathermap.org/img/wn/".freeze
  FORECAST_DAYS = 7

  def get_forecast(date, lat, lon)
    return { success: false, message: "Date out of range" } unless valid_date?(date)

    response = fetch_weather_data(lat, lon)
    return response unless response[:success]

    parse_forecast(response[:data], date)
  end

  private

  def fetch_weather_data(lat, lon)
    uri = URI(BASE_URL)
    uri.query = URI.encode_www_form(
      lat: lat,
      lon: lon,
      appid: ENV["OPENWEATHER_API_KEY"],
      exclude: "current,minutely,hourly,alerts",
      units: "metric"
    )

    response = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPOK)
      { success: true, data: JSON.parse(response.body) }
    else
      handle_error_response(response.code.to_i)
    end
  rescue JSON::ParserError
    { success: false, message: "Invalid JSON response" }
  rescue Net::HTTPError, Net::OpenTimeout, Net::ReadTimeout, SocketError => e
    { success: false, message: e.message }
  end

  def valid_date?(date)
    # OpenWeather returns daily forecast for 7 days
    date.to_date.between?(Date.today, FORECAST_DAYS.days.from_now.to_date)
  end

  def parse_forecast(data, target_date)
    forecast = data["daily"].find { |day| Time.at(day["dt"]).to_date == target_date.to_date }
    return { success: false, message: "Forecast not found for the given date" } unless forecast

    {
      success: true,
      description: forecast["summary"],
      humidity: forecast["humidity"],
      temperature: {
        min: forecast.dig("temp", "min"),
        max: forecast.dig("temp", "max")
      },
      icon: build_icon_url(forecast.dig("weather", 0, "icon"))
    }
  end

  def handle_error_response(status_code)
    message = case status_code
    when 400 then "Bad request - check your params"
    when 401 then "Unauthorized - check your API token"
    when 404 then "Not Found - wrong URL or lat/lon doesn't exist"
    when 429 then "Too Many Requests - retry later"
    else "Unexpected error occurred"
    end

    { success: false, message: message, error_code: status_code }
  end

  def build_icon_url(icon)
    icon.present? ? "#{ICON_BASE_URL}#{icon}@2x.png" : nil
  end
end
