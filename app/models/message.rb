class Message < ApplicationRecord
  belongs_to :user
  belongs_to :receiver, class_name: :User, foreign_key: :receiver_id
  belongs_to :chat_room

  def forward(from = nil)
    slack_api("chat.postMessage", {
      token:   chat_room.opposite.user.oauth.access_token,
      channel: chat_room.opposite.channel_id,
      text:    format_body(from),
      as_user: true
    })

    self
  end

  private

  def format_body(from)
    from ? "<@#{from}>#{body}"
         : body
  end
end
