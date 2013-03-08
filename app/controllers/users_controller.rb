class UsersController < ApplicationController
  def show
  	@user = User.find(params[:id])
  	#find by a certain index
  	#@user = User.find_by_nickname!(params[:nickname])
  	#@nickname = @user.nickname
  end

  def new
  end
end
