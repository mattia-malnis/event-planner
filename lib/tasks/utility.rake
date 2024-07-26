namespace :utility do
  desc "Get a list of events from goabase.net"
  task create_events: :environment do
    begin
      g = Goabase.new
      events_list = g.events_list
      Event.upsert_all(events_list) if events_list.any?

    rescue StandardError => e
      Rails.logger.error("Failed to create events: #{e.message}")
      raise e
    end
  end
end
