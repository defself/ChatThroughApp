class Oauth < ApplicationRecord
  belongs_to :user

  validates :user_id, uniqueness: true

  def authorize(code)
    return unless code

    rc = slack_api("oauth.access", {
      client_id:     ENV['CLIENT_ID'],
      client_secret: ENV['CLIENT_SECRET'],
      redirect_uri:  ENV['REDIRECT_URI'],
      code:          code
    })

    save_access_token(rc)
  end

  private

  def save_access_token(data)
    update_attributes(
      access_token:     data["access_token"],
      team_id:          data["team_id"],
      team_name:        data["team_name"],
      bot_user_id:      data["bot"]["bot_user_id"],
      bot_access_token: data["bot"]["bot_access_token"]
    )
  end
end
