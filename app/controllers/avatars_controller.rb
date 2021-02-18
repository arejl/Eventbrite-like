class AvatarsController < ApplicationController
  def new
    @user = User.find(params[:user_id])
  end
  def create
    @user = User.find(params[:user_id])
    @user.avatar.attach(params[:avatar])
    redirect_to(user_path(@user))
  end
end
