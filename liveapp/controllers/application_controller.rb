class ApplicationController < ActionController::Base
  protect_from_forgery
  private

  def after_sign_in_path_for(resource_or_scope)
    user_path(current_user)
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def require_login
    return if current_user

    flash[:alert] = "You must be logged in to view this page"
    redirect_to root_path
  end

  def require_admin
    return if current_user && current_user.admin?

    if request.xhr?
      status 403
      render json: { error: 'Permission Denied' }
    else
      flash[:alert] = "You must have admin rights for this action"
      redirect_to root_path 
    end
  end

  def require_permissible
    return if current_user && current_user.permissible?(params)

    if request.xhr?
      status 403
      render json: { error: 'Permission Denied' }
    else
      flash[:alert] = "You must have proper permission for this action"
      redirect_to root_path 
    end
  end

  def admin_or_current?
    current_user == @user ? require_login : require_admin
  end
end
