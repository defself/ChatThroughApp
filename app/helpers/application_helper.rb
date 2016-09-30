module ApplicationHelper
  def generate_slack_button
    image = image_tag("https://platform.slack-edge.com/img/add_to_slack@2x.png",
      alt: "Add to Slack"
    )

    params = {
      scope:        "bot,channels:write,chat:write:bot",
      client_id:    ENV["CLIENT_ID"],
      redirect_uri: ENV["REDIRECT_URI"],
      state:        "authorized"
    }.to_query

    link_to(image, "https://slack.com/oauth/authorize?#{params}")
  end
end
