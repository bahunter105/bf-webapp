class WorkshopsController < ApplicationController
  skip_before_action :authenticate_user!

  def workshops
    moodle = MoodleRb.new(ENV["MOODLE_WEBSERVICES_TOKEN"], ENV["MOODLE_URL"])
    moodle_workshops = moodle.courses.index
    # moodle_workshops.each do |workshop|
    #   if (workshop["id"] != 0 && Workshop.find_by(moodleid:workshop["id"]).nil?)
    #     p workshop["id"]
    #   end
    # end
    moodle_workshops.each do |workshop|
      if (workshop["id"] != 1 && Workshop.find_by(moodleid:workshop["id"]).nil?)
        new_workshop = Workshop.new
        new_workshop.fullname = workshop["fullname"]
        new_workshop.shortname = workshop["shortname"]
        summary_string = workshop["summary"].match(/>.+</).to_s
        new_workshop.summary = summary_string[1...-1]
        new_workshop.language = workshop["lang"]
        new_workshop.moodleid = workshop["id"]
        new_workshop.save
      end
    end

    @q = Workshop.ransack(params[:q])
    @workshops = @q.result(distinct: true)

  end

  def show
    @workshop = Workshop.find(params[:id])
  end

end
