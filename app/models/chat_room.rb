class ChatRoom < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy

  def slack_channel(app: false)
    unless id # create a chat_room if it doesn't exist
      chat = new_channel!
      update_attributes(
        channel_id: chat["channel"]["id"],
        name:       chat["channel"]["name"],
        team_id:    user.oauth.team_id
      )
      invite_bot!
    end

    slack_url(app)
  end

  private

  def new_channel!
    receiver = User.find_by_id(receiver_id)
    name     = receiver.channel_title # "chat_with_<receiver_user_name>"

    slack_api("channels.create", {
      name:  name,
      token: user.oauth.access_token
    })
  end

  def invite_bot!
    slack_api("channels.invite", {
      token:   user.oauth.access_token,
      channel: channel_id,
      user:    user.oauth.bot_user_id
    })
  end

  def slack_url(app)
    if app # deep link
      "slack://channel?id=#{channel_id}&team=#{user.oauth.team_id}"
    else   # web link
      "https://#{user.oauth.team_name}.slack.com/messages/#{name}"
    end
  end
end
