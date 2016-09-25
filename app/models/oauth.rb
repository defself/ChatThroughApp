require "http"
require "json"
require "faye/websocket"
require "eventmachine"

Thread.new do
  EM.run do
  end
end

class Oauth
  def self.get_access_token(code, current_user)
    rc = HTTP.post("https://slack.com/api/oauth.access", params: {
      client_id:     ENV['CLIENT_ID'],
      client_secret: ENV['CLIENT_SECRET'],
      code:          code
    })
    rc = JSON.parse(rc.body)
    current_user.update_attributes(bot_user_id:      rc["bot"]["bot_user_id"],
                                   bot_access_token: rc["bot"]["bot_access_token"])
    current_user.bot_access_token
  end

  def self.open_websocket(token)
    rc = JSON.parse(HTTP.post('https://slack.com/api/rtm.start', params: {
      token: token
    }))
    url = rc["url"]

    # Open a websocket
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

  def self.save_access_token(code, current_user)
    return unless code

    token = get_access_token(code, current_user)
    open_websocket(token)
  end
end
