class EventsController < ApplicationController
  include Pagy::Backend

  before_action :authenticate_user!
  before_action :find_event, only: [ :show, :toggle_subscription, :weather ]
  after_action :accessed_fields, only: :index

  def index
    # If we have the query string `all=y`, we show all the events; otherwise, only the events associated with the user
    @show_all = params[:all] == "y"
    @events = @show_all ? Event.all.ordered_with_country : current_user.events.ordered_with_country
    @pagy, @events = pagy(@events)
  end

  def show
  end

  # Toggles the subscription status of the current user for the event
  def toggle_subscription
    current_user.toggle_event!(@event)
  end

  def weather
    o = OpenWeather.new
    result = o.get_forecast(@event.date_start, @event.lat, @event.long)

    # No forecast found
    render plain: "" unless result.dig(:success)

    @description = result.dig(:description)
    @humidity = result.dig(:humidity)
    @min = result.dig(:temperature, :min)
    @max = result.dig(:temperature, :max)
    @icon = result.dig(:icon)
  end

  private

  # Finds the event by ID or renders a 404 page if not found
  def find_event
    @event = Event.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render file: Rails.root.join("public", "404.html"), status: :not_found, layout: false
  end

  def accessed_fields
    # usefull to optimize queries and select only necessary attrs
    return if Rails.env.production?

    puts ">>> list of accessed fields:"
    puts @events.first.accessed_fields
  end
end
