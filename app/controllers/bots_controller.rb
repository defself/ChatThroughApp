class BotsController < ApplicationController
  def create
    Bot.all.each do |bot|
      bot.kill    if     bot.alive
      bot.wake_up unless bot.alive
    end

    redirect_back(fallback_location: root_path)
  end
end
