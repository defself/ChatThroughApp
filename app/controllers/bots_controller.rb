class BotsController < ApplicationController
  def create
    all_users = params["all_users"] == "false"
    bots      = all_users ? current_user.chat_rooms.map(&:bot)
                          : Bot.all
    bots.each do |bot|
      bot.kill    if     bot.alive
      bot.wake_up unless bot.alive
    end

    redirect_back(fallback_location: root_path)
  end
end
