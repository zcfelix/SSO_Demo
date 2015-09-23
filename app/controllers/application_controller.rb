require 'net/http'

class ApplicationController < ActionController::Base
  before_filter :handle_cookies

  def handle_cookies 
    if cookies[:token].nil?
      redirect_to "https://www.baidu.com", status: 302
      # 展示重定向页面

    # has token, sent to vertify   
    else
      token = cookies[:token]
      json = send_to_vertify(token, url)
      if json[:status] == true
        # 展示页面，写cookie
        cookies[:token] = json[:token]
      else
        redirect_to "https://www.baidu.com", status: 302
      end
    end
  end

  def send_to_vertify(token, url)
    uri = URI.parse(url)
    args = {token: token}
    uri.query = URI.encode_www_form(args)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    response.body 
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
