class OauthsController < ApplicationController
  before_action :without_token

  def show
    if code = params[:code]
      Oauth.save_access_token(code, current_user)
      redirect_to users_path
    else
      render "home/welcome"
    end
  end

  protected

  def without_token
    redirect_to users_path if current_user.bot_access_token
  end
end
