class AccountsController < ApplicationController
  before_filter :require_login

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)
    if @account.save
      flash[:notice] = "Account Created"
      redirect_to account_path(@account)
    else
      flash[:error] = "Account Not Created"
      render :new
    end
  end

  def show
    @account = Account.includes(:views).find(params[:id])
  end

  def edit
    @account = Account.find(params[:id])
  end

  def update
    @account = Account.find(params[:id])
    if @account.update_attributes(account_params)
      flash[:notice] = "Account Updated"
      redirect_to account_path(@account)
    else
      flash[:error] = "Account Not Updated"
      render :edit
    end
  end

  private
    
    def account_params
      params.require(:account).permit(:name, :analytics_id)
    end
end
