class EventsController < ApplicationController
  include Pagy::Backend

  before_action :authenticate_user!
  before_action :find_event, only: [ :show, :toggle_subscription, :weather ]
  before_action :store_location, only: [ :index, :subscribed ]
  after_action :accessed_fields, only: [ :index, :subscribed ]

  def index
    @events = Event.all
    filter_and_paginate_events
  end

  def subscribed
    @events = current_user.events
    filter_and_paginate_events
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

  def store_location
    session[:return_to] = request.fullpath
  end

  def filter_and_paginate_events
    @events = filter_by_type(params[:filter])
    @events = filter_by_date_range(params[:date]) if params[:date].present?
    @events = @events.ordered_with_country

    @pagy, @events = pagy(@events)
  end

  def filter_by_type(filter)
    case filter
    when "all"
      @events
    when "past"
      @events.past
    else
      @events.upcoming
    end
  end

  def filter_by_date_range(date_param)
    date_start, date_end = date_param.split(" to ")
    return @events unless date_start.present? && date_end.present?

    date_end = date_end.to_date.at_end_of_day
    @events.where(date_start: date_start..date_end).or(@events.where(date_end: date_start..date_end))
  end

  # Finds the event by ID or renders a 404 page if not found
  def find_event
    @event = Event.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render file: Rails.root.join("public", "404.html"), status: :not_found, layout: false
  end

  def accessed_fields
    # usefull to optimize queries and select only necessary attrs
    return if Rails.env.production? || @events.blank?

    Rails.logger.debug ">>> List of accessed fields: #{@events.first.accessed_fields.join(", ")}"
  end
end
