class EventImporter
  MIN_DESCRIPTION_LENGTH = 50

  def import
    process_events(fetch_events)
    schedule_image_processing
  end

  private

  def fetch_events
    Rails.logger.info("Downloading events (this may take a while)")
    Goabase.new.events_list
  end

  def process_events(events_list)
    Rails.logger.info("Processing downloaded events")
    return if events_list.blank?

    events = build_events(events_list)
    import_events(events)
  end

  def build_events(events_list)
    return if events_list.blank?

    events_list.filter_map do |item|
      next if item[:description].to_s.size < MIN_DESCRIPTION_LENGTH # skip events with a short description

      country = find_or_create_country(item)

      {
        title: item[:title],
        description: item[:description],
        date_start: item[:date_start],
        date_end: item[:date_end],
        lat: item[:lat],
        long: item[:long],
        city: item[:city],
        external_ref: item[:id],
        temp_image_url: item[:image],
        country_id: country.id
      }
    end
  end

  def find_or_create_country(item)
    Country.find_or_create_by(iso: item[:country_iso]) do |c|
      c.name = item[:country]
    end
  end

  def import_events(events)
    return if events.blank?

    Event.upsert_all(events, unique_by: :external_ref)
    Rails.logger.info("Events imported")
  end

  def schedule_image_processing
    ids = Event.where.not(temp_image_url: [ nil, "" ]).ids
    ids.each { |id| EventImageProcessingJob.perform_later(id) }
    Rails.logger.info("Scheduled image processing for #{ids.count} events")
  end
end
