class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:coming_soon, :home]

  def coming_soon

  end

  def home
  end
end
