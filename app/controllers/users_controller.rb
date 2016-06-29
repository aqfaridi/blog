class UsersController < ApplicationController
  load_and_authorize_resource

  def index
  	@users = User.all
  end

  def show 
  end

  def edit
  	@user = User.find(params[:id])
  end

  def update
  	@user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = 'User has been updated successfully !!'
      redirect_to users_path
    else
      render 'edit'
    end
  end

  def destroy
  	@user = User.find(params[:id])
    @user.destroy
    flash[:success] = 'User has been deleted successfully !!'
    redirect_to users_path
  end

  private
  def user_params
    params.require(:user).permit(:email, :avatar, roles:[])
  end

end
