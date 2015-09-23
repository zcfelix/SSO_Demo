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
    #login_server = "http://192.168.1.21/index.php?r=192.168.1.13:8080/token"
    if cookies[:sso_token].nil?
      redirect_to "http://192.168.1.21/index.php?r=192.168.1.13:8080/token"
      # 展示重定向页面

    # has token, sent to vertify   
    else
      t = cookies[:sso_token]
      #url = "https://baidu.com?token=#{t}"
      url = "https://vertify_server/token/#{t}"
      json = send_to_vertify(url)
      if json[:status] == true
        render
      else
        redirect_to "http://192.168.1.21/index.php?r=192.168.1.13:8080/token"
      end
    end
  end

  def send_to_vertify(url)
    user_cert_file = Rails.root.join('app.pem')
    user_key_file = user_cert_file

    http = HTTPClient.new
    http.ssl_config.set_client_cert_file(user_cert_file, user_key_file)
    response = http.get(url)
    response.body 
    #{name: "Felix", id: 123}
  end

  def token
    t = params[:token]
    url = "https://verify_server/token/#{t}"
    #url = "https://www.baidu.com?token=#{t}"
    json = send_to_vertify(url)
    @current_user = json[:user_data]
    #@current_user = { name: "Felix", id: 2 }
    session[:current_user] = @current_user
    cookies[:sso_token] = t
    render
  end

  def set_current_user
    @current_user = session[:current_user]
  end
end
