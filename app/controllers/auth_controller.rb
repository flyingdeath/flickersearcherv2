class AuthController < ApplicationController

  require 'flickraw'
  skip_before_filter :auth_start_app, :only => [:auth_start, :auth_finish]


  def auth_start
    unless session[:authing]

      require 'flickraw'
      FlickRaw.secure = true
      FlickRaw.ca_file = (File::join Rails.root, 'cert.pem').to_s

      FlickRaw.api_key = "<your key here>"
      FlickRaw.shared_secret = "<your shared Secret here>"
      session[:authing] = true
      token           = flickr.get_request_token
      session[:token] = token
      @auth_url       = flickr.get_authorize_url(token['oauth_token'], :perms => 'delete')
      render '/auth/auth_start'
    end
  end

  def auth_finish
    session[:authing] = false
    begin
      flickr.get_access_token(session[:token]['oauth_token'], session[:token]['oauth_token_secret'], params[:verify])
      login = flickr.test.login()
      session[:access_token] =  flickr.access_token
      session[:access_secret] = flickr.access_secret
      Rails.logger.debug "You are now authenticated as #{login.username} with token #{flickr.access_token} and secret #{flickr.access_secret}"
    rescue FlickRaw::FailedResponse => e
      Rails.logger.debug "Authentication failed : #{e.msg}"
    end
    redirect_to  session[:request_url]
  end

end
