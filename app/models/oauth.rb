require "faye/websocket"
require "eventmachine"

Thread.new do
  EM.run do
  end
end

class Oauth < ApplicationRecord
  belongs_to :user

  include Slack::API

  def save_access_token!(code)
    return unless code

    get_access_token!(code)
    open_websocket!
  end

  def get_access_token!(code)
    rc = slack_api("oauth.access", {
      client_id:     ENV['CLIENT_ID'],
      client_secret: ENV['CLIENT_SECRET'],
      redirect_uri:  ENV['REDIRECT_URI'],
      code:          code
    })

    update_attributes(
      access_token:     rc["access_token"],
      team_id:          rc["team_id"],
      team_name:        rc["team_name"],
      bot_user_id:      rc["bot"]["bot_user_id"],
      bot_access_token: rc["bot"]["bot_access_token"]
    )
  end

  def open_websocket!
    url = slack_api("rtm.start", {
      token: bot_access_token
    })["url"]

    ws = Faye::WebSocket::Client.new(url)

    ws.on :open do
      p [:open]
    end

    ws.on :message do |event|
      data = JSON.parse(event.data) if event && event.data
      p [:message, data]

      if data && data['type'] == 'message' && data['text'] == 'hi'
        ws.send({ type: 'message', text: "hi <@#{data['user']}>", channel: data['channel'] }.to_json)
      end
    end

    ws.on :close do |event|
      p [:close, event.code, event.reason]
      ws = nil
      EM.stop
    end
  end
end
