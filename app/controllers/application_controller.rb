class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter  :auth_start_app


  Rails.logger = Logger.new(STDOUT)

  def auth_start_app
    unless session[:access_token]
      session[:request_url] = request.url
      redirect_to  :controller => 'auth', :action =>  "auth_start"
    else
      flickr.access_token =  session[:access_token]
      flickr.access_secret =  session[:access_secret]
    end

  end

end

