class OauthsController < ApplicationController
  before_action :slack_authorized!

  def show
    if code = params[:code]
      o = Oauth.create!(user: current_user)
      o.save_access_token!(code)

      redirect_to users_path
    else
      render "home/welcome"
    end
  end

  protected

  def slack_authorized!
    if current_user&.slack_authorized?
      current_user.oauth.open_websocket!

      redirect_to root_path
    end
  end
end
