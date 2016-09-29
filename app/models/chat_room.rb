class ChatRoom < ApplicationRecord
  belongs_to :user
  belongs_to :receiver, class_name: :User, foreign_key: :receiver_id
  has_many :messages, dependent: :destroy
  has_one :bot

  def slack_channel(app: false)
    # create a new channel if the chat_room doesn't exist
    unless id
      chat = new_channel
      update_attributes(
        channel_id: chat["channel"]["id"],
        name:       chat["channel"]["name"]
      )
    end

    create_bot.invite_to_channel unless bot
    bot.wake_up                  unless bot.alive

    slack_url(app)
  end

  def opposite
    receiver.chat_rooms.find_by(receiver_id: user_id)
  end

  private

  def new_channel
    receiver = User.find_by_id(receiver_id)
    name     = receiver.channel_title # "chat_with_<receiver>"

    slack_api("channels.create", {
      name:  name,
      token: user.oauth.access_token
    })
  end

  def slack_url(app)
    app ? "slack://channel?id=#{channel_id}&team=#{user.oauth.team_id}" # deep link
        : "https://#{user.oauth.team_name}.slack.com/messages/#{name}"  # web link
  end
end
