require 'open-uri'

class UsersController < ApplicationController

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def show
  	#@user = User.find(params[:id])
    #unless @user
    @user = User.where(nickname: params[:id]).first!
    #end
    # TODO @refresh controls the presence of the refresh button.  Show the button, but make it disabled instead of hiding it
    @refresh = true
    @refresh = Time.now > @user.last_refreshed + Rails.application.config.refresh_threshold_in_seconds if @user.last_refreshed
    @user_stats = @user.stats_returner(false)
    @match_stats = @user.match_stats.paginate(page: params[:page], per_page: 25).order('date_played DESC')
    gon.gpms = @match_stats.reduce([]) {|coll, obj| coll << (obj.gpm)}.reverse
    gon.apms = @match_stats.reduce([]) {|coll, obj| coll << (obj.apm)}.reverse
    gon.match_numbers = @match_stats.reduce([]){|coll, obj| coll << obj.match_number}.reverse
    gon.gold = [@user_stats["avg_creep_gold"], @user_stats["avg_neutral_gold"], 
                  @user_stats["avg_gold_from_hero_kill"]]
    # TODO make this more railsy/elegant
    mmrs = [@user.mmr]
    index = 1
    @match_stats.each do |match|
      mmrs << (mmrs[index-1] + match.rating_change).round(2)
      index+=1
    end
    gon.mmrs = mmrs.reverse
  end

  def index
  	@users = User.order("nickname ASC").paginate(page: params[:page], per_page: 25)
  end

  def new
    open("http://www.heroesofnewerth.com")
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
        @user.last_refreshed = Time.now
        if @user.save
          MatchStat.build_update_user(@user)
          redirect_to user_path(@user.nickname) and return
        end
      end
    end
    render 'new'
  end

  def update
    #begin
    # TODO Make this cleaner and take calls to save out of the method
      @user = User.find(params[:id])
      @refresh = true
      #@refresh = Time.now > @user.last_refreshed + Rails.application.config.refresh_threshold_in_seconds if @user.last_refreshed
      @user_stats = @user.stats_returner(@refresh)
      if @refresh and @user_stats
        @user_stats.each_key {|field| @user.send("#{field}=", @user_stats[field])}
        @user.save
      end
      logger.debug "In update event for user #{@user.inspect}"
      @recent_string = recent_game_stats_for(@user)
      MatchStat.build_update_user(@user)
      @user.last_refreshed = Time.now
    #rescue Exception => e
      #logger.error("************* User update failed with error: #{e}")
    #end
    redirect_to user_path(@user.nickname)
  end

  #   Returns the last 25 matches this player has played
  #   TODO: Check for errors eg if the player has fewer than 25 matches
  #     Potentially have these methods take in the user obj
  #     make sure these records don't get duplicated
  #     add a game-date/time to the match/matchstat objects
  #
  def recent_game_stats_for(usr)
    #refined = []
    processed = []
    begin
      #processed = []
      account_id = usr.hon_id     #TODO make this better.  Use user id for everything.
      full_history = match_history_for(usr.nickname)          #returns an array whose 0th element is a comma-separated string of all matches played since 2011
      history_split = full_history[0]["history"].split(',') #separate the matches, which are further separated into "<match-id>| 2 | <date>"
      #recent_string_25 = history_split[-25].split('|')[0]   
      #history_split[-24,24].each do |frag| #string of the last 25 match ids separated by a "+"
      #  recent_string_25 << "+" << frag.split('|')[0]
      #end
      arr_25 = history_split.collect {|match| match.split('|')[0]}
      arr_25 = arr_25[-25,25] if arr_25.size >= 25
      recent_string_25 = arr_25.join("+")
      #logger.debug "Recent String: #{recent_string_25}"
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
      #refined = processed.inject([]) do |r, p|kroy
      #refined = processed.collect do |p|

      #TODO outsource this to MatchStat model
      #refined = MatchStat.parse_match(multimatch_raw)
      #@refined = @stats.select {|s| s["hon_id"]==account_id}
      
    rescue Exception => e
      logger.debug e
      #@refined = false
      processed = false
    end
    
    return processed
  end

  def match_history_for(nick)
    #json = open "http://api.heroesofnewerth.com/match_history/ranked/nickname/#{nick}/?token=#{Rails.application.config.hon_api_token}"
    json = open "http://api.heroesofnewerth.com/match_history/ranked/nickname/#{nick}/?token=VSCSVSL01BZWF5F4"
    return JSON.parse(json.read)
  end

  def match_stats_multimatch_for(matchId)
    json = open "http://api.heroesofnewerth.com/multi_match/all/matchids/#{matchId}/?token=VSCSVSL01BZWF5F4"
    return JSON.parse(json.read)
  end

  def items
    json = open "http://api.heroesofnewerth.com/items/name/Item_Weapon1/?token=VSCSVSL01BZWF5F4"
    return JSON.parse(json.read)
  end

  private
    def record_not_found
      redirect_to "/notfound"
    end

end
