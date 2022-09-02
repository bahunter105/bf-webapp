class BookmarksController < ApplicationController
  def index
  end

  def show
    @bookmark = Bookmark.find(params[:id])
  end

  def create
    @bookmark = Bookmark.new(bookmark_params)
    @bookmark.save
    # No need for app/views/bookmarks/create.html.erb
    redirect_to bookmark_path(@bookmark)
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    workshop_id = @bookmark.workshop.id
    @bookmark.destroy
    redirect_to bookmarks_path(id: workshop_id)#, status: :see_other
  end

  private

  def bookmark_params
    params.permit(:user_id, :workshop_id)
  end
end
