namespace :utility do
  desc "Get a list of events from goabase.net"
  task create_events: :environment do
    begin
      g = Goabase.new
      events_list = g.events_list

      if events_list.any?
        events = events_list.map do |item|
          next if item[:description].to_s.size < 50 # skip events with a short description

          country = Country.find_or_create_by(iso: item[:country_iso]) do |c|
            c.name = item[:country]
          end

          {
            title: item[:title],
            description: item[:description],
            date_start: item[:date_start],
            date_end: item[:date_end],
            lat: item[:lat],
            long: item[:long],
            city: item[:city],
            external_ref: item[:id],
            country_id: country.id
          }
        end

        events.compact_blank!
        Event.upsert_all(events, unique_by: :external_ref) if events.any?
      end

    rescue StandardError => e
      Rails.logger.error("Failed to create events: #{e.message}")
      raise e
    end
  end
end
