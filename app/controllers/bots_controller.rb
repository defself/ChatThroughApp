class BotsController < ApplicationController
  def create
    current_user.chat_rooms.each do |chat|
      chat.bot.wake_up unless chat.bot.alive
    end

    redirect_back(fallback_location: root_path)
  end

  def destroy
    current_user.chat_rooms.each do |chat|
      chat.bot.kill if chat.bot.alive
    end

    redirect_back(fallback_location: root_path)
  end
end
