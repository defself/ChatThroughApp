module Slack
  module API
    extend ActiveSupport::Concern

    SLACK_API = "https://slack.com/api/"

    included do
      def slack_api(method, params = {})
        JSON.parse(HTTP.post(SLACK_API + method, params: params).body)
      end
    end
  end
end
