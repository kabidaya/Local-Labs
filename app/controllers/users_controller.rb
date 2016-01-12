class UsersController < ApplicationController
require "rubygems"
require "json"
  def show
    @title = "My Account | LocalLabs"
    @user = User.find(params[:id])
    admin_or_current?

    if request.xhr?
      render json: { view_ids: @user.views.pluck(:id) }
    else
      @views = @user.admin? ? View.all : @user.views.order("name ASC")
      @accounts = Account.where(id: @views.collect{ |v| v.account.id }.uniq)
    end
  end

  def update
   @user = User.find(params[:id])
   if @user.update_attributes(user_params)
     sign_in @user
     flash[:notice] = "User saved"
     redirect_to user_path(@user)
   else
     flash[:alert] = "User not saved"
     render :edit
   end
  end

  protected

   def user_params
     params.require(:user).permit(:name, :email, :password, :password_confirmation)
   end
end
