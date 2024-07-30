namespace :utility do
  desc "Import events from goabase.net"
  task import_events: :environment do
    Rails.logger = Logger.new(STDOUT)
    Rails.logger.level = Logger::INFO

    Rails.logger.info("Starting event import from goabase.net")

    EventImporter.new.import

    Rails.logger.info("Event import completed successfully")
  rescue StandardError => e
    Rails.logger.error("Failed to import events: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    raise e
  end
end
