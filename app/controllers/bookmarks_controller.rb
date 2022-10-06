class BookmarksController < ApplicationController
  
  before_action :ensure_signed_in
  
  def index
    @bookmarks = current_user.bookmarks.order(id: :desc)
    
  end

  def create
    @bookmark = Bookmark.new(create_bookmark_params)
    @checkbookmark= current_user.bookmarks.where(:title => @bookmark.title).first.blank?
    
    if @checkbookmark
      
      @bookmark.user = current_user
      @bookmark.save
      
      render status: 200, template: 'headlines', json: { bookmark: @bookmark, success: true }
    else
      errors = @bookmark.errors.full_messages.join(', Might be already saved')
      render json: {
        errors: errors+"Might be already saved",
        success: false
      }
     
    end
    
  end

  def destroy
    @checkbookmark= current_user.bookmarks.where(:id => params[:id]).blank?
    if @checkbookmark
      flash[:bookmark] = "This bookmark seems already removed from portfolio"      
      redirect_to :root
    else
      @bookmark = current_user.bookmarks.find(params[:id])
      @bookmark.destroy!
      flash[:bookmark] = "#{@bookmark.note} was  removed from portfolio"      
      redirect_to :root
    end
  end

  private

  def create_bookmark_params 
    params.require(:bookmark).permit(:title, :link, :note)
  end

end