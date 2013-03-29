class UsersController < ApplicationController
  TOKEN = "KSXOOT43JUQJ2RQM"
  def show
  	@user = User.find(params[:id])
    @user_stats = @user.stats_returner(true)
    @match_stats = @user.match_stats.paginate(page: params[:page], per_page: 25)
    #@recent_stats = recent_game_stats_for(@user.nickname)
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
    @user = User.new
  end

  #TODO make this better so that it's using stats_returner, not acct_stats_fetch
  #This is here purely to facilitate my own testing.  Password Hardcoded
  def create
    @user = User.new({:nickname => params[:user][:nickname]})
    if params[:user][:password] == "noobs4evr"
      stats = @user.stats_returner(true)
      if stats
        # TODO this is bad fix it
        stats.each_key {|field| @user.send("#{field}=", stats[field])}
        if @user.save
          recent_string = recent_game_stats_for(@user.nickname)
          if recent_string
            recent_string.each do |statline|
              ms = @user.match_stats.build()
              statline.each_key {|field| ms.send("#{field}=", statline[field])}
              #ms.win = statline[:win]
              ms.save #continue
            end
          end
          redirect_to @user and return
        end
      end
    end
    render 'new'
  end

  #   Returns the last 25 matches this player has played
  #   TODO: Check for errors eg if the player has fewer than 25 matches
  #     Potentially have these methods take in the user obj
  #     make sure these records don't get duplicated
  #
  def recent_game_stats_for(nick)
    refined = []
    begin
      processed = []
      account_id = User.find_by_nickname(nick).hon_id     #TODO make this better.  Use user id for everything.
      full_history = match_history_for(nick)          #returns an array whose 0th element is a comma-separated string of all matches played since 2011
      history_split = full_history[0]["history"].split(',') #separate the matches, which are further separated into "<match-id>| 2 | <date>"
      recent_string_25 = history_split[-25].split('|')[0]   #string of the last 25 match ids separated by a "+"
      history_split[-24,24].each do |frag|
        recent_string_25 << "+" << frag.split('|')[0]
      end
      multimatch_raw = match_stats_multimatch_for(recent_string_25)
      
      multimatch_raw[1].each do |inv_summ|
        if inv_summ["account_id"]==account_id
          #add the inv data to the proper array entry 
          processed.push(inv_summ)
        end
      end
      slot = 0
      #@TODO Make this less icky
      multimatch_raw[2].each do |stats|
        if stats.value?(account_id)
          processed.each do |part|
            if part.value?(stats["match_id"])
              part.merge!(stats)
            end
          end
        end
      end
      # This is a pain TODO fix it
      #refined = processed.inject([]) do |r, p|
      #refined = processed.collect do |p|
      processed.each do |p|
        refined << {:win => p["wins"].to_i, :hero_id => p["hero_id"].to_i, :team => p["team"].to_i, :position => p["position"].to_i, :hero_kills => p["herokills"].to_i,
                  :deaths => p["deaths"].to_i, :hero_assists => p["heroassists"].to_i, :level => p["level"].to_i, :item_1 => p["slot_1"].to_i, 
                  :item_2 => p["slot_2"].to_i,:item_3 => p["slot_3"].to_i, :item_4 => p["slot_4"].to_i, :item_5 => p["slot_5"].to_i, :item_6 => p["slot_6"].to_i,
                  :rating_change => p["amm_team_rating"].to_f, :gold_lost_death => p["goldlost2death"].to_i, :secs_dead => p["secs_dead"].to_i, 
                  :hero_dmg => p["hero_dmg"].to_i, :hero_kill_exp => p["heroexp"].to_i, :hero_kill_gold => p["herokillsgold"].to_i, 
                  :creep_kills => p["teamcreepkills"].to_i, :creep_dmg => p["teamcreepdmg"].to_i, :creep_exp => p["teamcreepexp"].to_i, 
                  :creep_gold => p["teamcreepgold"].to_i, :neutral_kills => p["neutralcreepkills"].to_i, :neutral_dmg => p["teamcreepdmg"].to_i, 
                  :neutral_exp => p["neutralcreepexp"].to_i, :neutral_gold => p["neutralcreepgold"].to_i, :building_dmg => p["bdmg"].to_i, 
                  :building_gold => p["bgold"].to_i, :denies => p["denies"].to_i, :exp_denied => p["exp_denied"].to_i, :gold => p["gold"].to_i,
                  :gold_spent => p["gold_spent"].to_i, :exp => p["exp"].to_i, :actions => p["actions"].to_i, :secs => p["secs"].to_i, 
                  :consumables => p["consumables"].to_i, :wards => p["wards"].to_i, :nickname => p["nickname"], :hon_id => p["account_id"].to_i, :match_number => p["match_id"].to_i}
      end
    rescue
      refined = false
    end
    
    return refined
  end

  def match_history_for(nick)
    json = open "http://api.heroesofnewerth.com/match_history/ranked/nickname/#{nick}/?token=#{TOKEN}"
    return JSON.parse(json.read)
  end

  def match_stats_multimatch_for(matchId)
    json = open "http://api.heroesofnewerth.com/multi_match/all/matchids/#{matchId}/?token=#{TOKEN}"
    return JSON.parse(json.read)
  end
end
