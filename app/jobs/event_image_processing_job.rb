class EventImageProcessingJob < ApplicationJob
  queue_as :default

  def perform(event_id)
    event = Event.find_by(id: event_id)

    if event.nil?
      Rails.logger.error("Event with ID #{event_id} not found")
      return
    end

    begin
      event.attach_image_from_url
    rescue StandardError => e
      Rails.logger.error("Failed to process image for event ID #{event_id}: #{e.message}")
      raise e
    end
  end
end
