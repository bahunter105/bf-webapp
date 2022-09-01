class BookmarksController < ApplicationController
  def show
    @bookmark = Bookmark.find(params[:id])
  end

  def create
    @bookmark = Bookmark.new(bookmark_params)
    @bookmark.save
    # No need for app/views/bookmarks/create.html.erb
    redirect_to bookmark_path(@bookmark)
  end

  private

  def bookmark_params
    params.permit(:user_id, :workshop_id)
  end
end
