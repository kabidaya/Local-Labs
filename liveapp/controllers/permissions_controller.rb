class PermissionsController < ApplicationController
  def index
    admin_or_current?
    @user = User.find(params[:user_id])
    render json: { data: @user.views.pluck(:id) }
  end

  def create
    admin_or_current?
    @user = User.find(params[:user_id])

    old_permissions = @user.permissions.pluck(:view_id)
    begin
      @user.permissions.destroy_all

      params[:view_ids].each do |view_id|
        @user.views << View.find(view_id)
      end if params[:view_ids]

      render json: { data: params[:view_ids] }
    rescue Exception => e
      old_permissions = @user.permissions.pluck(:view_id)
      @user.permissions.destroy_all
      old_permissions.each do |view_id|
        @user.views << View.find(view_id)
      end
      render json: { data: old_permissions }, status: 401
    end

  end
end
