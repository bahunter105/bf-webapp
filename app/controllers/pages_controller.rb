class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:coming_soon, :home, :family_home, :educator_home, :webinar, :courses, :about, :contact_us]

  def coming_soon
    render layout: "simple"
  end

  def home
  end

  def family_home
  end

  def educator_home
  end

  def webinar
  end

  def courses
  end

  def ambassador_family
  end

  def ambassador_educator
  end

  def about
  end

  def contact_us
  end

  def grow_with_me
  end

  def account
    @user = current_user
    all_workshops = Workshop.all
    @workshops = all_workshops.joins(:bookmarks).where("user_id = #{current_user.id}")
  end
end
