class UsersController < ApplicationController
  TOKEN = "KSXOOT43JUQJ2RQM"
  def show
  	@user = User.find(params[:id])
    @user_stats = stats_returner(@user, true)

    #if !@user.user_stats.any?

    #end
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

  ##   Helper Methods   ##

  # TODO Add logic to only automatically refresh if requested or if the stats are more than x hrs old
  protected
  def stats_returner(user, refresh)
    returner = {}
    stats = {}
    if refresh
      stats = acct_stats_fetch(user.nickname)
      stats.each_key do |field|
        user.send("#{field}=", stats[field])
      end
      user.save
      returner = stats
    else
      returner = {"mmr"=>user.mmr, "games_played" => user.games_played, "wins"=>user.wins, "losses"=>user.losses, "kills"=>user.kills, 
                    "deaths"=>user.deaths, "assists"=>user.assists, "secs"=>user.secs, "secs_dead"=>user.secs_dead, "avg_hero_damage"=>user.avg_hero_damage,
                    "avg_exp"=>user.avg_exp, "gold"=>user.gold, "avg_gold_from_hero_kill"=>user.avg_gold_from_hero_kill,
                    "avg_gold_lost_deaths"=>user.avg_gold_lost_deaths, "avg_creep_kills"=>user.avg_creep_kills, "avg_creep_exp"=>user.avg_creep_exp,
                    "avg_creep_gold"=>user.avg_creep_gold, "avg_neutral_kills"=>user.avg_neutral_kills, "avg_neutral_exp"=>user.avg_neutral_exp,
                    "avg_neutral_gold"=>user.avg_neutral_gold, "avg_building_gold"=>user.avg_building_gold, "avg_wards"=>user.avg_wards,
                    "avg_denies"=>user.avg_denies}
    end
    return returner
  end

  protected
  def acct_stats_fetch(nick)
    # TODO add error handling
    json = open "http://api.heroesofnewerth.com/player_statistics/ranked/nickname/#{nick}/?token=#{TOKEN}"
    unfiltered = JSON.parse(json.read)
    
    filtered = {}

    #   Populate the hash to be returned to the view
    #
    numgames = unfiltered["rnk_games_played"].to_i
    filtered["mmr"] = unfiltered["rnk_amm_team_rating"].to_f
    #filtered["account_id"] = unfiltered["account_id"]
    filtered["games_played"] = numgames
    filtered["wins"] = unfiltered["rnk_wins"].to_i
    #filtered["win_pct"] = (unfiltered["rnk_wins"].to_f/numgames *100).round(0)
    filtered["losses"] = unfiltered["rnk_losses"].to_i
    #filtered["loss_pct"] = (unfiltered["rnk_losses"].to_f/numgames *100).round(0)
    filtered["kills"] = unfiltered["rnk_herokills"].to_i
    filtered["deaths"] = unfiltered["rnk_deaths"].to_i
    filtered["assists"] = unfiltered["rnk_heroassists"].to_i
    filtered["secs"] = unfiltered["rnk_secs"].to_i
    filtered["secs_dead"] = unfiltered["rnk_secs_dead"].to_i
    filtered["avg_hero_damage"] = (unfiltered["rnk_herodmg"].to_f/numgames).round(0)
    filtered["avg_exp"] = (unfiltered["rnk_heroexp"].to_f/numgames).round(1)
    filtered["gold"] = unfiltered["rnk_gold"].to_i
    filtered["avg_gold_from_hero_kill"] = (unfiltered["rnk_herokillsgold"].to_f/numgames).round(1)
    filtered["avg_gold_lost_deaths"] = (unfiltered["rnk_goldlost2death"].to_f/numgames).round(1)
    filtered["avg_creep_kills"] = (unfiltered["rnk_teamcreepkills"].to_f/numgames).round(0)
    filtered["avg_creep_exp"] = (unfiltered["rnk_teamcreepexp"].to_f/numgames).round(0)
    filtered["avg_creep_gold"] = (unfiltered["rnk_teamcreepgold"].to_f/numgames).round(0)
    filtered["avg_neutral_kills"] = (unfiltered["rnk_teamcreepkills"].to_f/numgames).round(0)
    filtered["avg_neutral_exp"] = (unfiltered["rnk_teamcreepexp"].to_f/numgames).round(0)
    filtered["avg_neutral_gold"] = (unfiltered["rnk_teamcreepgold"].to_f/numgames).round(0)
    filtered["avg_building_gold"] = (unfiltered["rnk_bgold"].to_f/numgames).round(0)
    filtered["avg_wards"] = (unfiltered["rnk_wards"].to_f/numgames).round(1)
    filtered["avg_denies"] = (unfiltered["rnk_denies"].to_f/numgames).round(0)
    #filtered["kdr"] = (unfiltered["rnk_herokills"].to_f/unfiltered["rnk_deaths"].to_f).round(3)
    #filtered["kadr"] = ((unfiltered["rnk_herokills"].to_f + unfiltered["rnk_heroassists"].to_f)/unfiltered["rnk_deaths"].to_f).round(3)
    #filtered["avg_secs_dead"] = unfiltered["rnk_secs_dead"].to_f/numgames
    #filtered["pct_time_dead"] = ((unfiltered["rnk_secs_dead"].to_f/unfiltered["rnk_secs"].to_f) *100).round(3)
    #filtered["avg_gpm"] = ((unfiltered["rnk_gold"].to_f/unfiltered["rnk_secs"].to_f)*60.0).round(0)
    
    
    #filtered["pct_time_earning_exp"] = ((unfiltered["rnk_time_earning_exp"].to_f/unfiltered["rnk_secs"].to_f)*100).round(2) #fairly useless stat

    #   leaving out kill streak data for now; not sure what I want to do with it

    return filtered
  end
end
