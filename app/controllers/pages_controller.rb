class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:coming_soon, :home, :family_home, :educator_home, :webinar, :courses, :about, :contact_us]

  def coming_soon
  end

  def home
    session[:cookies_accepted] = nil
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
  end
end
