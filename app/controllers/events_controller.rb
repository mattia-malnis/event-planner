class EventsController < ApplicationController
  before_action :authenticate_user!

  def index
    # If we have the query string `all=y`, we show all the events; otherwise, only the events associated with the user
    @show_all = params[:all] == "y"
    @events = @show_all ? Event.all.ordered : current_user.events.ordered
  end
end
