class UsersController < ApplicationController
  def index
    @users = User.joins(:oauth).where("oauths.access_token IS NOT NULL AND users.id != ?", current_user.id)
  end
end
