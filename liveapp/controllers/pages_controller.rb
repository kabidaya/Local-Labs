class PagesController < ApplicationController
  def home
    redirect_to user_path(current_user) if current_user
  end

  def manage_views
    require_admin
    @users = User.non_admin.includes(:permissions)
    @accounts = Account.includes(:views)
  end
end
