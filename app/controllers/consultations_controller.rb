class ConsultationsController < ApplicationController
  before_action :set_user, only: %i[new create]

  def show
    @consultation = Consultation.find(params[:id])
  end

  def new
    if @user.remaining_consultations <= 0
      flash[:purchase_consultations] = "You have no purchased consultations remaining"
    else
      flash[:notice] = "You have #{@user.remaining_consultations} consultations remaining"
    end

    @consultation = Consultation.new # Needed to instantiate the form_with
    calendar = Google::Apis::CalendarV3::CalendarService.new
    scope = 'https://www.googleapis.com/auth/calendar'
    authorizer = Google::Auth::ServiceAccountCredentials.from_env(scope: scope)
    calendar.authorization = authorizer
    calendar_id = 'hunter@brightfutures.net'
    result = calendar.list_events(calendar_id,
                                    max_results: 100,
                                    single_events: true,
                                    order_by: 'startTime',
                                    time_min: Time.now.iso8601)
    @events = result.items
    gon.result = @events
  end

  def create
    if @user.remaining_consultations <= 0
      redirect_to account_path, purchase_consultations: "Consultation not scheduled. You have no purchased consultations remaining."
      return
    end

    @consultation = Consultation.new
    @consultation.user = @user
    @consultation.date_time = params[:date_time]
    # @consultation.date_time = Time.now
    @consultation.save
    calendar = Google::Apis::CalendarV3::CalendarService.new
    scope = 'https://www.googleapis.com/auth/calendar'
    authorizer = Google::Auth::ServiceAccountCredentials.from_env(scope: scope)
    calendar.authorization = authorizer
    calendar_id = 'hunter@brightfutures.net'
    # pry
    event = Google::Apis::CalendarV3::Event.new(
      summary: 'Bright Futures Consultation',
      location: 'Online',
      description: 'Follow the link to access the consultation',
      start: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: @consultation.date_time.iso8601,
        # time_zone: 'America/Chicago'
      ),
    end: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: (@consultation.date_time + 3600).iso8601,
        # time_zone: 'America/Chicago'
      ),
      # recurrence: [
      #   'RRULE:FREQ=DAILY;COUNT=2'
      # ],
      # attendees: [
      #   Google::Apis::CalendarV3::EventAttendee.new(
      #     email: 'bahunter+consultation@gmail.com'
      #   ),
      #   # Google::Apis::CalendarV3::EventAttendee.new(
      #   #   email: 'sbrin@example.com'
      #   # )
      # ],
      reminders: Google::Apis::CalendarV3::Event::Reminders.new(
        use_default: true,
        # overrides: [
        #   Google::Apis::CalendarV3::EventReminder.new(
        #     reminder_method: 'email',
        #     minutes: 24 * 60
        #   ),
        #   Google::Apis::CalendarV3::EventReminder.new(
        #     reminder_method: 'popup',
        #     minutes: 10
        #   )
        # ]
      )
    )

    result = calendar.insert_event(calendar_id, event)
    puts "Event created: #{result.id}"
    @consultation.gcal_event_id = result.id
    @consultation.save

    @user.remaining_consultations -= 1
    @user.save

    redirect_to account_path, notice: "You have successfully changed your consultation"
  end

  def destroy
    @consultation = Consultation.find(params[:id])

    calendar = Google::Apis::CalendarV3::CalendarService.new
    scope = 'https://www.googleapis.com/auth/calendar'
    authorizer = Google::Auth::ServiceAccountCredentials.from_env(scope: scope)
    calendar.authorization = authorizer
    calendar_id = 'hunter@brightfutures.net'
    event = @consultation.gcal_event_id
    calendar.delete_event(calendar_id, event)

    @consultation.destroy
    current_user.remaining_consultations += 1
    current_user.save
    redirect_to account_path, notice: "Your account has been credited with a consultation", status: :see_other
  end

  private
  def set_user
    @user = User.find(params[:user_id])
  end

  def consultation_params
    # params.require(:consultation)
    params.require(:date_time)
  end
end
