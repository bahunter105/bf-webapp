class ConsultationsController < ApplicationController

  def new
    @consultation = Consultation.new # Needed to instantiate the form_with
    calendar = Google::Apis::CalendarV3::CalendarService.new
    scope = 'https://www.googleapis.com/auth/calendar'
    authorizer = Google::Auth::ServiceAccountCredentials.from_env(scope: scope)
    calendar.authorization = authorizer
    calendar_id = 'hunter@brightfutures.net'
    @result = calendar.list_events(calendar_id,
                                    max_results: 10,
                                    single_events: true,
                                    order_by: 'startTime',
                                    time_min: Time.now.iso8601)


  end

  def create
    @consultation = Consultation.new(consultation_params)
    @consultation.save
    # No need for app/views/consultations/create.html.erb
    redirect_to consultation_path(@consultation)
  end

  private

  def consultation_params
    params.require(:consultation).permit(:name, :address, :rating)
  end
end
