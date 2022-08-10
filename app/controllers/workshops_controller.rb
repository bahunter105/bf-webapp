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
      if (workshop["id"] != 0 && Workshop.find_by(moodleid:workshop["id"]).nil?)
        new_workshop = Workshop.new
        new_workshop.fullname = workshop["fullname"]
        new_workshop.shortname = workshop["shortname"]
        new_workshop.summary = workshop["summary"]
        new_workshop.language = workshop["lang"]
        new_workshop.save
      end
    end

    @workshops = Workshop.all
  end

  def show
    @workshop = Workshop.find(params[:id])
  end

end
