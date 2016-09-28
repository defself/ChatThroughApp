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
      listen_chat(event)
    end

    @ws.on :close do |event|
      go_to_sleep(event)
    end

    self
  end

  def kill(options = {})
    @ws.close(options) if @ws
    update_attributes(alive: false)

    self
  end

  private

  def open_websocket
    p [:open]
    update_attributes(alive: true)
  end

  def listen_chat(event)
    data = JSON.parse(event.data) if event && event.data
    p [:message, data]

    if data && data['type'] == 'message' && data['text'] == 'hi'
      @ws.send({ type: 'message', text: "hi <@#{data['user']}>", channel: data['channel'] }.to_json)
    elsif data && data['type'] == 'message' && data['text'].include?('fuck')
      @ws.send({ type: 'message', text: "I'm going home!", channel: data['channel'] }.to_json)
      kill(code: 666, reason: "bad word")
    end
  end

  def go_to_sleep(event)
    p [:close, event.code, event.reason]
    @ws = nil
    EM.stop
    update_attributes(alive: false)
  end
end
