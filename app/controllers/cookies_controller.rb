class CookiesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    session[:cookies_accepted] = params[:cookies] if params[:cookies]
  end
end
