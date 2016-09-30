class UsersController < ApplicationController
  skip_before_filter :authenticate_user!

  def index
    @users = if current_user
      User.joins(:oauth).where("oauths.access_token IS NOT NULL AND users.id != ?", current_user.id)
    else
      []
    end
  end
end
