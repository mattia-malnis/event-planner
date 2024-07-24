class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_event, only: [ :show, :toggle_subscription ]

  def index
    # If we have the query string `all=y`, we show all the events; otherwise, only the events associated with the user
    @show_all = params[:all] == "y"
    @events = @show_all ? Event.all.ordered : current_user.events.ordered
  end

  def show
  end

  # Toggles the subscription status of the current user for the event
  def toggle_subscription
    current_user.toggle_event!(@event)
  end

  private

  # Finds the event by ID or renders a 404 page if not found
  def find_event
    @event = Event.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render file: Rails.root.join("public", "404.html"), status: :not_found, layout: false
  end
end
