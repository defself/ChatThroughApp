class OauthsController < ApplicationController
  def authorize
    if params[:state] == "authorized" &&
       code = params["code"]
      o = current_user.oauth || current_user.create_oauth
      o.authorize(code)
    end

    redirect_to root_path
  end
end
