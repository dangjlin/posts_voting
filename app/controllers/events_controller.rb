class EventsController < ApplicationController
  respond_to :json
  before_action :set_event, only: [:update]

  def index
    respond_with Event.all
  end

  def create
    event = Event.new(event_params)
    if event.save
      respond_with :api, event, status: :ok, location: api_events_url
    else
      render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      respond_with :api, @event, status: :ok, location: api_event_url(@event)
    else
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def search
    query = params[:query]
    events = Event.where('name LIKE ? OR place LIKE ? OR description LIKE ?',
                        "%#{query}%", "%#{query}%", "%#{query}%")

    respond_with events
  end


  private

  def event_params
    params.require(:event).permit(:name, :description, :event_date, :place)
  end

  def set_event
    @event = Event.find(params[:id])
  end
end
