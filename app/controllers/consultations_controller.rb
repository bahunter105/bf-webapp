class ConsultationsController < ApplicationController
  before_action :set_user, only: %i[new create]

  def show
    @consultation = Consultation.find(params[:id])
  end

  def new
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
    @consultation = Consultation.new
    @consultation.user = @user
    @consultation.date_time = params[:date_time]
    @consultation.save
    redirect_to account_path
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
