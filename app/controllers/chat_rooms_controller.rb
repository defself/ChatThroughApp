class ChatRoomsController < ApplicationController
  before_action :slack_authorized!

  def create
    chat_room = ChatRoom.find_or_initialize_by(
      user_id:     current_user.id,
      receiver_id: params[:user_id]
    )
    app = params[:app] == "true"
    channel_url = chat_room.slack_channel(app: app)

    redirect_to channel_url
  end

  protected

  def slack_authorized!
    redirect_to root_path unless current_user&.slack_authorized?
  end
end
