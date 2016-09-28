class OauthsController < ApplicationController
  def authorize
    if params[:state] == "authorized" &&
       code = params["code"]
      o = current_user.oauth || Oauth.create!(user: current_user)
      o.save_access_token!(code)
    elsif current_user&.slack_authorized?
      current_user.oauth.open_websocket!
    end

    redirect_to root_path
  end
end
