require "rails_helper"

RSpec.describe "Api::Events", type: :request do
  let(:user) { FactoryBot.create :user }
  let(:country) { FactoryBot.create :country }
  let!(:events) { FactoryBot.create_list(:event, 5, country:) }

  def auth_headers(user)
    { "Authorization" => "Bearer #{user.api_key}" }
  end

  describe "GET /api/events" do
    it "raise unauthorized error with no API key" do
      get api_events_path, as: :json

      expect(response).to have_http_status(401)
    end

    it "fetch all events list" do
      get api_events_path(all: "y"), headers: auth_headers(user), as: :json

      # Expect a successful response (HTTP status 200)
      expect(response).to have_http_status(200)

      # Parse the response JSON and check if has got the "data" key and count values
      response_json = JSON.parse(response.body)
      expect(response_json).to have_key("data")
      expect(response_json["data"].count).to eq(events.count)
    end

    it "fetch user events list" do
      # Assign some events to user
      events[0..2].each { |event| user.events << event }

      get api_events_path, headers: auth_headers(user), as: :json

      # Expect a successful response (HTTP status 200)
      expect(response).to have_http_status(200)

      # Parse the response JSON and check if has got the "data" key and count values
      response_json = JSON.parse(response.body)
      expect(response_json).to have_key("data")
      expect(response_json["data"].count).to eq(user.events.count)
    end
  end

  describe "POST /api/events" do
    it "create a new event" do
      event_params = {
        title: FFaker::Lorem.phrase,
        date_start: FFaker::Date.backward,
        date_end: FFaker::Date.forward,
        city: FFaker::Address.city,
        lat: 78.291,
        long: 12.32,
        country: {
          iso: FFaker::Address.country_code,
          name: FFaker::Address.country
        }
      }
      post api_events_path, params: event_params, headers: auth_headers(user), as: :json

      # Expect a successful response (HTTP status 200)
      expect(response).to have_http_status(200)

      # Parse the response JSON and check if contains all the necessary keys
      response_json = JSON.parse(response.body)
      expect(response_json).to have_key("data")
      expect(response_json["data"].keys).to include("id", "title", "description", "date_start", "date_end", "city", "lat", "long", "country", "image_url")
    end

    it "raise validation error" do
      event_params = { title: FFaker::Lorem.phrase }

      post api_events_path, params: event_params, headers: auth_headers(user), as: :json

      expect(response).to have_http_status(422)
    end
  end

  describe "PUT /api/events/:id" do
    it "update an event" do
      event = events.first
      backup_title = event.title

      event_params = { title: FFaker::Lorem.phrase }
      put api_event_path(event), params: event_params, headers: auth_headers(user), as: :json

      # Expect a successful response (HTTP status 200)
      expect(response).to have_http_status(200)

      # Parse the response JSON and check if contains all the necessary keys
      response_json = JSON.parse(response.body)
      expect(response_json).to have_key("data")
      expect(response_json["data"].keys).to include("id", "title", "description", "date_start", "date_end", "city", "lat", "long", "country", "image_url")

      # Reload the event and check if the title has been updated
      event.reload
      expect(backup_title).not_to eq(event.title)
    end
  end

  describe "DELETE /api/events" do
    it "delete an event" do
      event = events.first
      delete api_event_path(event), headers: auth_headers(user), as: :json

      # Expect a successful response (HTTP status 200)
      expect(response).to have_http_status(200)

      # Parse the response JSON and check if contains all the necessary keys
      response_json = JSON.parse(response.body)
      expect(response_json).to have_key("data")
      expect(response_json["data"].keys).to include("id", "title", "description", "date_start", "date_end", "city", "lat", "long", "country")

      # Ensure the event is deleted from the database
      expect(Event.exists?(event.id)).to be false
    end
  end
end
