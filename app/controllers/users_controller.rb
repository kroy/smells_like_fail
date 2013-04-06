class UsersController < ApplicationController
  TOKEN = "KSXOOT43JUQJ2RQM"
  def show
  	@user = User.find(params[:id])
    #refresh = @user.last_updated > 5.seconds.ago
    refresh = true
    @user_stats = @user.stats_returner(refresh)
    if refresh and @user_stats
      @user_stats.each_key {|field| @user.send("#{field}=", @user_stats[field])}
      @user.save
    end
    @match_stats = @user.match_stats.paginate(page: params[:page], per_page: 25).order('created_at DESC')
    
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
          # @recent_string = recent_game_stats_for(@user)
          # if @recent_string
          #   @recent_string.each do |statline|
          #     ms = @user.match_stats.build()
          #     # TODO this needs to go in a separate place. Only here so i can get it working
          #     # if the corresponding match doesn't exist, create it
          #     match = Match.find_by_match_number(statline[:match_number])
          #     unless match
          #       match = Match.new(:match_number => statline["match_id"].to_i, :duration_seconds => statline["secs"].to_i, 
          #               :winner => (((statline["wins"].to_i) + (statline["team"]).to_i)%2 +1)) #add date played
          #       match.save
          #     end
          #     ms.match_id = match.id
          #     @stats = statline.dup
          #     ms.fill_stats(@stats)
          #     #statline.each_key {|field| ms.send("#{field}=", statline[field])}
          #     #ms.save
          #   end
          # 
          #end
          MatchStat.build_user(@user)
          redirect_to @user and return
        end
      end
    end
    render 'new'
  end

  def update

    @user = User.find(params[:id])
    logger.debug "In update event for user #{@user.inspect}"
    @recent_string = recent_game_stats_for(@user)
    #logger.debug "Recent String: #{recent_string}"
    #user_stats = recent_string.select{|s| s["hon_id"] == @user.hon_id}
    if @recent_string
      @recent_string.each do |statline|
        ms = @user.match_stats.build()
        # TODO this needs to go in a separate place. Only here so i can get it working
        # if the corresponding match doesn't exist, create it
        match = Match.find_by_match_number(statline[:match_number])
        unless match
          match = Match.new(:match_number => statline["match_id"].to_i, :duration_seconds => statline["secs"].to_i, 
                        :winner => (((statline["wins"].to_i) + (statline["team"]).to_i)%2 +1)) #add date played
          match.save
        end
        ms.match_id = match.id
        @stats = statline.dup
        ms.fill_stats(@stats)
        #statline.each_key {|field| ms.send("#{field}=", statline[field])}
        #ms.save #continue
      end
    end
    redirect_to @user
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
    json = open "http://api.heroesofnewerth.com/match_history/ranked/nickname/#{nick}/?token=#{TOKEN}"
    return JSON.parse(json.read)
  end

  def match_stats_multimatch_for(matchId)
    json = open "http://api.heroesofnewerth.com/multi_match/all/matchids/#{matchId}/?token=#{TOKEN}"
    return JSON.parse(json.read)
  end

  def items
    json = open "http://api.heroesofnewerth.com/items/name/Item_Weapon1/?token=#{TOKEN}"
    return JSON.parse(json.read)
  end
end
