class WorkshopsController < ApplicationController
  skip_before_action :authenticate_user!

  def workshops
    moodle = MoodleRb.new(ENV['MOODLE_WEBSERVICES_TOKEN'], ENV['MOODLE_URL'])
    moodle_workshops = moodle.courses.index

    moodle_workshops.each do |workshop|
      next if workshop['id'] == 1
      next if Workshop.find_by(moodleid: workshop['id'])

      new_workshop = Workshop.new
      new_workshop.fullname = workshop['fullname']
      new_workshop.shortname = workshop['shortname']
      new_workshop.language = workshop['lang']
      new_workshop.moodleid = workshop['id']

      summary_string = workshop['summary'].match(/>.+</).to_s
      new_workshop.summary = summary_string[1...-1]

      case workshop['categoryid']
      when 1
        new_workshop.category = 'families'
      when 2
        new_workshop.category = 'educators'
      else
        new_workshop.category = 'families'
      end

      new_workshop.save
    end
    @q = Workshop.ransack(params[:q])
    @workshops = @q.result(distinct: true)
    if params[:fav] == '1'
      @workshops = @workshops.joins(:bookmarks).where("user_id = #{current_user.id}")
    end
  end

  def show
    @workshop = Workshop.find(params[:id])
  end
end
