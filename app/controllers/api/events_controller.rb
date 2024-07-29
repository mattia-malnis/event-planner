class Api::EventsController < ApiController
  wrap_parameters format: [] # Disable parameter wrapping: rails append authomatically the "event" key to the params
  before_action :find_event, only: [ :show, :update, :destroy ]
  rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
  rescue_from ActionController::UnpermittedParameters, with: :handle_unpermitted_params

  # GET /api/events
  # Returns a list of events
  def index
    # If we have the query string `all=y`, we show all the events; otherwise, only the events associated with the user
    @events = if params[:all] == "y"
      Event.all.ordered
    else
      @current_user.events.ordered
    end

    @events = @events.eager_load(:country)
    @pagy, @events = pagy(@events)
    @pagination = pagy_metadata(@pagy)
  end

  # POST /api/events
  # Creates a new event based on the provided parameters
  def create
    @event = Event.new(event_params.except(:country))
    @event.country = find_or_create_country(event_params[:country]) if event_params[:country].present?
    @event.save!
    render "show"
  end

  # PUT /api/events/:id
  # Updates the specified event based on the provided parameters.
  def update
    @event.assign_attributes(event_params.except(:country))
    @event.country = find_or_create_country(event_params[:country]) if event_params[:country].present?
    @event.save!
    render "show"
  end

  # DELETE /api/events/:id
  # Deletes the specified event.
  def destroy
    @event.destroy!
    render "show"
  end

  private

  def event_params
    permitted_params = [ :title, :description, :date_start, :date_end, :lat, :long, :city, country: [ :iso, :name ] ]
    params.permit(permitted_params)
  end

  # Finds the event by ID or renders a 404 if not found
  def find_event
    @event = Event.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { message: "Record #{params[:id]} not found" }, status: :not_found
  end

  # Finds or creates the country based on the ISO code
  def find_or_create_country(country_params)
    return unless country_params.present?

    Country.find_or_create_by!(iso: country_params[:iso]) do |country|
      country.name = country_params[:name]
    end
  end

  def handle_record_invalid(instance)
    @errors = instance.record.errors.messages
    render "error", status: :unprocessable_entity
  end

  def handle_unpermitted_params(instance)
    render json: { message: "Unpermitted params found: #{instance.params.join(", ")}" }, status: :bad_request
  end
end
