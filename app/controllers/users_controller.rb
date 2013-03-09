class UsersController < ApplicationController
  def show
  	@user = User.find(params[:id])
  	#parsed = stats_for(@user.nickname)
  	#games_played = parsed["rnk_games_played"]
  	#find by a certain index
  	#@user = User.find_by_nickname!(params[:nickname])
  	#@nickname = @user.nickname
  end

  def index
  	@users = User.order("nickname ASC").paginate(page: params[:page], per_page: 25)
  end

  def new
  end
end
