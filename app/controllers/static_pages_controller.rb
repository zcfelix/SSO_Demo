require 'net/https'
require 'httpclient'

class StaticPagesController < ApplicationController
  before_filter :set_current_user
  before_filter :handle_cookies, except: [:token]

  def home
  end

  def sign_out
    session[:current_user] = nil
  end

  def redirect
  end

  def handle_cookies 
    if !cookies[:sso_token].nil?
      redirect_to "https://www.baidu.com"
      #redirect_to "https://www.haohao.com/index.php?r=me.com/token?token=xxxx"
      # 展示重定向页面

    # has token, sent to vertify   
    else
      t = cookies[:sso_token]
      url = "https://baidu.com?token=#{t}"
      json = send_to_vertify(url)
      if json[:status] == true
        # 展示页面
      else
        redirect_to "https://www.baidu.com"
      end
    end
  end

  def send_to_vertify(url)
    http = HTTPClient.new
    response = http.get(url)
    #response.body 
    {name: "Felix", id: 123}
  end

  def token
    t = params[:token]
    url = "https://www.baidu.com?token=#{t}"
    json = send_to_vertify(url)
    #@current_user = json[:user_data]
    @current_user = { name: "Felix", id: 2 }
    session[:current_user] = @current_user
    cookies[:sso_token] = t
    render
  end

  def set_current_user
    @current_user = session[:current_user]
  end
end
