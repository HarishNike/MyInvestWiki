require 'will_paginate/array'
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  
  helper_method :current_user 

  private

  
  def sign_in(user)
    token = SecureRandom.urlsafe_base64 
    session[:session_token] = token
    user.update_attribute(:session_token, token)

  end

  
  def current_user 
    @current_user ||= find_current_user
  end

  def find_current_user 
    token = session[:session_token]
    token && User.find_by(session_token: token)
  end

  def sign_out
    
    session.delete(:session_token)
    
    current_user.update_attribute(:session_token , nil)
  end

  def ensure_signed_in 
    return if current_user
    flash[:error] = 'Please sign in to view this page'
    redirect_to :login
  end

  def ensure_signed_out
    return unless current_user
    flash[:error] = 'You are already logged in'
    redirect_to :root
  end

  def fetch_news
    url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=abd97c8d2b4e4052a4e7db978d6ef606"
    response = HTTParty.get url
    @articles = response.parsed_response['articles'] unless response.code != 200
  end
  
end
