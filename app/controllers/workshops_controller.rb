class WorkshopsController < ApplicationController
  skip_before_action :authenticate_user!

  def workshops
    moodle = MoodleRb.new(ENV['MOODLE_WEBSERVICES_TOKEN'], ENV['MOODLE_URL'])
    moodle_workshops = moodle.courses.index

    moodle_workshops.each do |workshop|
      next if workshop['id'] == 1
      next if Workshop.find_by(moodle_id: workshop['id'])

      new_workshop = Workshop.new
      new_workshop.fullname = workshop['fullname']
      new_workshop.shortname = workshop['shortname']
      new_workshop.language = workshop['lang']
      new_workshop.moodle_id = workshop['id']

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
    @h='hi'
    if params[:fav] == '1'
      @h='bye'
      @workshops = @workshops.joins(:bookmarks).where("user_id = #{current_user.id}")
    end
  end

  def show
    @workshop = Workshop.find(params[:id])
  end

  def add_to_cart
    id = params[:id].to_i
    session[:ws_cart] << id unless session[:ws_cart].include?(id)
    redirect_to workshops_path
  end

  def remove_from_cart
    id = params[:id].to_i
    session[:ws_cart].delete(id)
    redirect_to workshops_path
  end

  def add_to_cart_ws_page
    workshop = Workshop.find(params[:id])
    id = params[:id].to_i
    session[:ws_cart] << id unless session[:ws_cart].include?(id)
    redirect_to workshops_path(workshop)
  end

  def remove_from_cart_cart_page
    id = params[:id].to_i
    session[:ws_cart].delete(id)
    redirect_to cart_path
  end

end
