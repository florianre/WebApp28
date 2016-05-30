class EventsController < ApplicationController
  # No authentification needed to see events (can't see all elements)
  skip_before_action :authenticate_user!, :only => [:index]

  GET_ALL_EVENTS_QUERY =
    "SELECT to_char(events.date, 'FMDDth FMMonth YYYY') AS date,
            to_char(events.start_time, 'HH24:MI') AS start_time,
            to_char(events.end_time, 'HH24:MI') AS end_time,
            events.sport,
            events.location,
            events.needed,
            events.min_participants,
            events.participants,
            events.university_location,
            users.first_name,
            users.last_name,
            university_mails.university_name
     FROM events JOIN users ON events.user_id = users.id
     JOIN university_mails ON users.email ILIKE ('%@' || university_mails.mail_extension);"

  def index
    @events = ActiveRecord::Base.connection.execute(GET_ALL_EVENTS_QUERY)

    respond_to do |format|
      format.json { render json: @events }
    end
  end

  def create
    current_user_id = current_user.id

    # Create new entry and store it in the events table of the database
    # Parameters of new event are given from the HTTP POST request
    new_event =
      Event.create(:sport => params[:sport],
                   :date => params[:date],
                   :start_time => params[:start_time],
                   :end_time => params[:end_time],
                   :university_location => params[:university_location],
                   :location => params[:location],
                   :needed => params[:needed],
                   :min_participants => params[:min_participants],
                   :additional_info => params[:additional_info],
                   :participants => 1,
                   :user_id => current_user_id)

    # Create new event participant and store it in the event_participants
    # table of the database
    # Parameters are given from current user id and created event id
    EventParticipant.create(:event_id => new_event.id,
                            :user_id => current_user_id)

    render :nothing => true
  end
end
