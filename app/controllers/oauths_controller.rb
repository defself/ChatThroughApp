class OauthsController < ApplicationController
  def show
    if code = params[:code]
      Oauth.save_access_token(code)
      redirect_to users_path
    else
      render "home/welcome"
    end
  end
end
