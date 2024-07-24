require "net/http"
require "json"

class Goabase
  BASE_URL = "https://www.goabase.net".freeze

  def events_list
    remote_list.map do |item|
      {
        title: item["nameParty"],
        description: event_details(item["id"]),
        country: item["nameCountry"],
        date: item["dateStart"],
        lat: item["geoLat"],
        long: item["geoLon"]
      }
    end
  end

  private

  def remote_list
    fetch_json("/api/party/json?limit=50").dig("partylist") || []
  end

  def event_details(id)
    fetch_json("/api/party/json/#{id}").dig("party", "textMore")
  end

  def fetch_json(path)
    begin
      uri = URI("#{BASE_URL}#{path}")
      response = Net::HTTP.get_response(uri)

      if response.is_a?(Net::HTTPSuccess)
        JSON.parse(response.body)
      else
        Rails.logger.error("Failed to fetch data from #{path}: #{response.code} #{response.message}")
        {}
      end

    rescue JSON::ParserError => e
      Rails.logger.error("Failed to parse JSON from #{path}: #{e.message}")
      {}
    rescue StandardError => e
      Rails.logger.error("Error fetching data from #{path}: #{e.message}")
      {}
    end
  end
end
