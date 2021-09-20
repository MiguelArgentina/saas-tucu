class UsersController < ApplicationController
  def index
    @users = User.all
  end
  
  def resend_invite
    user = User.find(params[:id])
    user.invite!
    redirect_to users_path, notice: "Invitation for #{user} has been re sent"
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  
end
