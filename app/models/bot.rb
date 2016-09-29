Thread.new do
  EM.run do
  end
end

class Bot < ApplicationRecord
  belongs_to :chat_room

  validates :chat_room_id, uniqueness: true

  def invite_to_channel
    slack_api("channels.invite", {
      token:   chat_room.user.oauth.access_token,
      channel: chat_room.channel_id,
      user:    chat_room.user.oauth.bot_user_id
    })
  end

  def wake_up
    url = slack_api("rtm.start", {
      token: chat_room.user.oauth.bot_access_token
    })["url"]

    @ws = Faye::WebSocket::Client.new(url) unless alive

    @ws.on :open do
      open_websocket
    end

    @ws.on :message do |event|
      listen_channel(event)
    end

    @ws.on :close do |event|
      close_websocket(event)
    end

    self
  end

  def kill(options = {})
    @ws.close(options) if @ws
    update_attributes(alive: false)

    self
  end

  def forward_message(msg, from = nil)
    chat_room.messages.create(
      body:     msg,
      user:     chat_room.user,
      receiver: chat_room.receiver
    ).forward(from)
  end

  private

  def open_websocket
    p [:open]
    update_attributes(alive: true)
  end

  def listen_channel(event)
    data = JSON.parse(event.data) if event && event.data

    return unless
      data["channel"] == chat_room.channel_id &&
      data["type"]    == "message" &&
      data["user"]    == chat_room.user.oauth.slack_user_id &&
      !data["text"].include?("@#{chat_room.opposite.user.oauth.slack_user_id}")

    bot_id = chat_room.user.oauth.bot_user_id

    case msg = data["text"]
    when /<@#{bot_id}>/
      @ws.send({ type: "message", text: "hi <@#{data['user']}>", channel: data["channel"] }.to_json)
    when /fuck/
      @ws.send({ type: "message", text: "I'm going home!", channel: data["channel"] }.to_json)
      kill(code: 666, reason: "bad word")
    else
      chat_room.opposite ? forward_message(msg, data["user"])
                         : @ws.send({ type:    "message",
                                      text:    "Wait a minute! Your partner did not accept invitation yet. Please, try again later.",
                                      channel: data["channel"] }.to_json)
    end
  end

  def close_websocket(event)
    p [:close, event.code, event.reason]
    @ws = nil
    EM.stop
    update_attributes(alive: false)
  end
end
