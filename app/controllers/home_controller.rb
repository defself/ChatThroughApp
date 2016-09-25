class HomeController < ApplicationController
  def welcome
    if current_user && current_user.bot_access_token
      Oauth.open_websocket(current_user.bot_access_token)
      redirect_to users_path
    end
  end
end
