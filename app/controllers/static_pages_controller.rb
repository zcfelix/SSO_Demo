require 'net/https'
require 'httpclient'

class StaticPagesController < ApplicationController
  before_filter :set_current_user
  before_filter :handle_cookies, except: [:get_token]

  def home
  end

  def sign_out
    session[:current_user] = nil
  end

  def redirect
  end

  def handle_cookies 
    if cookies[:sb_token].nil?
      redirect_to "https://www.baidu.com"
      #redirect_to "https://www.haohao.com/index.php?r=me.com/get_token?t=xxxx"
      # 展示重定向页面

    # has token, sent to vertify   
    else
      token = cookies[:sb_token]
      url = "https://baidu.com?token=#{token}"
      json = send_to_vertify(url)
      if json[:status] == true
        # 展示页面，写cookie
        cookies[:sb_token] = json[:token]
      else
        redirect_to "https://www.baidu.com"
      end
    end
  end

  def send_to_vertify(url)
    http = HTTPClient.new
    response = http.get(url)
    #response.body 
    {name: "abc", id: 123}
  end

  def get_token
    token = params[:token]
    url = "https://www.baidu.com?token=#{token}"
    @json = send_to_vertify(url)
    @current_user = { name: "cool", id: 2 }
    session[:current_user] = @current_user
    render
  end

  def set_current_user
    @current_user = session[:current_user]
  end
end
