require "http"
require "json"
require "faye/websocket"
require "eventmachine"

class Oauth
  def self.save_access_token(code)
    return unless code

    rc = HTTP.post("https://slack.com/api/oauth.access", params: {
      client_id:     ENV['CLIENT_ID'],
      client_secret: ENV['CLIENT_SECRET'],
      code:          code
    })
    rc = JSON.parse(rc)
    token = rc["bot"]["bot_access_token"]

    rc = JSON.parse(HTTP.post('https://slack.com/api/rtm.start', params: {
      token: token
    }))
    url = rc.url

    EM.run do
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
end
