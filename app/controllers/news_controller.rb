require 'json'
class NewsController < ApplicationController
  before_action :ensure_signed_in
  before_action :fetch_news, only: [:headlines]

  def home
    @bookmarks = current_user.bookmarks.order(id: :desc).paginate(:page => params[:page], :per_page => 5)
    
    # @temp=current_user.stocks.as_json
    @stocks=[]
    # @stocks=current_user.stocks.as_json
    @stocks=current_user.stocks.paginate(:page => params[:stock_page], :per_page => 5)

    @urls= 'https://cloud.iexapis.com/v1/stock/'
    @urlt='/quote?token=pk_b722f96a6a00437f9cd57b76f75b6128'
    @stockInfo='Check out the Share price and prev Info of symbol '\

    @url='https://cloud.iexapis.com/v1/stock/AAPL/quote?token=pk_b722f96a6a00437f9cd57b76f75b6128'
    # @temp.each do |temp|
    #     @query=fetch_stock_query temp['ticker']
    #     @stocks.push(JSON.parse(@query.to_s))
    # end
    
    # @bookmarked=current_user.bookmarks
  end
  
  def wiki  
    query = params[:q]
    @articles =fetch_news_wiki query
    @bookmarked=current_user.bookmarks
    @articles ||= []
    if current_user 
      @bookmark = current_user.bookmarks.new
    end
  end

  def index
    # placeholder for images that do not exist
    @image_placeholder = 'https://placehold.it/50x50'
    @articles ||= []
    @bookmarked=current_user.bookmarks
    if current_user 
      @bookmark = current_user.bookmarks.new
    end
  end

  def headlines
    @image_placeholder = 'https://placehold.it/50x50'
    @articles ||= []
    @bookmarked=current_user.bookmarks
    if current_user 
      @bookmark = current_user.bookmarks.new
    end
  end

  def search
    @image_placeholder = 'https://placehold.it/50x50'
    query = params[:q]
    @bookmarked=current_user.bookmarks
    @articles = fetch_news_query query unless !query
    @articles ||= [] # empty array if no query

    if current_user 
      @bookmark = current_user.bookmarks.new
    end
  end

  private


  def fetch_stock_query query
    url = "https://cloud.iexapis.com/v1/stock/"+query+"/quote?token=pk_b722f96a6a00437f9cd57b76f75b6128"
    response = HTTParty.get url
    return response.body unless response.code != 200  
  end
  def fetch_news_query query
    url = "https://newsapi.org/v2/everything?q=#{query}&apiKey=abd97c8d2b4e4052a4e7db978d6ef606"
    response = HTTParty.get url
    response.parsed_response['articles'] unless response.code != 200
  end

  def fetch_news_wiki query
    url = "https://newsapi.org/v2/everything?q=#{query}&apiKey=abd97c8d2b4e4052a4e7db978d6ef606"
    response = HTTParty.get url
    response.parsed_response['articles'] unless response.code != 200
  end

end