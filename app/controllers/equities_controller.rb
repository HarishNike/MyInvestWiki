class EquitiesController < ApplicationController
before_action :ensure_signed_in

def search
    @userStocks=current_user.stocks.all
    query = params[:q]
    @stocks=[]
    
    if query == nil
        @ajaxcall='https://cloud.iexapis.com/v1/stock/market/list/iexvolume?token=pk_b722f96a6a00437f9cd57b76f75b6128'
        @stocks=fetch_market_query
        @stocks=@stocks.to_s
        @stocks=JSON.parse(@stocks) 
    else 
        @ajaxcall="https://cloud.iexapis.com/v1/stock/"+query+"/quote?token=pk_b722f96a6a00437f9cd57b76f75b6128"
        @temp=fetch_stock_query query
        if(@temp==nil)
            flash[:error] = 'Please Enter Valid Stock Symbol'
            redirect_to :equities
        else
            @stocks=[]
            @stocks.push(JSON.parse(@temp.to_s)) 
        end
    end
end

def index 
    @temp=current_user.stocks.as_json
    @stocks=[]
    # @stocks=fetch_stock_query temp['ticker']
    # @temp.each do |temp|
    #     @query=fetch_stock_query temp['ticker']
    #     @stocks.push(JSON.parse(@query.to_s))
    # end
    
end

def destroy
    stock = Stock.where(ticker: params[:ticker]).first
    user_stock = UserStock.where(user_id: current_user.id, stock_id: stock.id).first
    if user_stock.blank?
        flash[:equitywishlist] = "#{stock.ticker} was already removed from portfolio"
        redirect_to :root
    else 
        user_stock.destroy
        flash[:equitywishlist] = "#{stock.ticker} was successfully removed from portfolio"
        redirect_to :root
    end
end


def create
    @name=params[:name]
    @ticker=params[:ticker]
    @stock = Stock.check_db(@ticker)
    if @stock.blank?
        @stock = Stock.new(ticker: @ticker,name: @name)
        @stock.save
    end

    
    if current_user.stocks.where(:ticker=>@ticker).blank?
        @user_stock = UserStock.create(user: current_user, stock: @stock)
        flash[:info] = @name +" was successfully added to your portfolio"
        redirect_to equities_path
    else
        flash[:info]=@name+"was already added to your portfolio"
        redirect_to equities_path
    end
end

def check
    @stocks=[]
    @stocks=current_user.stocks.paginate(:page => params[:page], :per_page => 1)
    
end



def chart
    query=params[:query]
    @articles = fetch_chart_query  query
    @articles=@articles.to_s
    @articles= JSON.parse(@articles)
    @prices=[]
    @dates=[]
    @open=[]
    @close=[]
    
    @low=[]
    @high=[]
    @bookmarked=current_user.bookmarks 
    if current_user 
        @bookmark = current_user.bookmarks.new
    end
    
    @articles.each do |item|
        @symbol=item['symbol']
        @close.push(item['close'])
        @high.push(item['high'])
        @low.push(item['low'])
        @open.push(item['open'])
        @dates.push(item['priceDate'])
    end
    
    @news=fetch_news_query query
    @news=@news.to_s
    @news= JSON.parse(@news)
    @news=@news.paginate(:page => params[:stock_news_page], :per_page => 5)
    
    
    
end




def fetch_news_query query
    url = "https://cloud.iexapis.com/v1/stock/"+query+"/news?token=pk_b722f96a6a00437f9cd57b76f75b6128"
    response = HTTParty.get url
   
    return response.body unless response.code != 200
end


def fetch_stock_query query
    url = "https://cloud.iexapis.com/v1/stock/"+query+"/quote?token=pk_b722f96a6a00437f9cd57b76f75b6128"
    response = HTTParty.get url
    
    return response.body unless response.code != 200
end

def fetch_chart_query query
    url = "https://cloud.iexapis.com/v1/stock/"+query+"/chart?token=pk_b722f96a6a00437f9cd57b76f75b6128"
    response = HTTParty.get url
    
    return response.body unless response.code != 200
  end
  

#   ,:headers => { 
#     'Content-Type' => 'application/json' }

def fetch_market_query 
    url = "https://cloud.iexapis.com/v1/stock/market/list/iexvolume?token=pk_b722f96a6a00437f9cd57b76f75b6128"
    response = HTTParty.get(url)
    
    return response.body unless response.code != 200
  end


end
