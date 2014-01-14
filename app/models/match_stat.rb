# == Schema Information
#
# Table name: match_stats
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  match_id        :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  hero_id         :integer
#  position        :integer
#  hero_kills      :integer
#  deaths          :integer
#  hero_assists    :integer
#  level           :integer
#  item_1          :integer
#  item_2          :integer
#  item_3          :integer
#  item_4          :integer
#  item_5          :integer
#  item_6          :integer
#  rating_change   :float
#  gold_lost_death :integer
#  secs_dead       :integer
#  hero_dmg        :integer
#  hero_kill_exp   :integer
#  hero_kill_gold  :integer
#  creep_kills     :integer
#  creep_dmg       :integer
#  creep_exp       :integer
#  creep_gold      :integer
#  neutral_kills   :integer
#  neutral_dmg     :integer
#  neutral_exp     :integer
#  neutral_gold    :integer
#  building_dmg    :integer
#  building_gold   :integer
#  denies          :integer
#  exp_denied      :integer
#  gold            :integer
#  gold_spent      :integer
#  exp             :integer
#  actions         :integer
#  secs            :integer
#  consumables     :integer
#  wards           :integer
#  combo_kill      :string(255)
#  ks              :string(255)
#  match_number    :integer
#  nickname        :string(255)
#  hon_id          :integer
#  win             :integer
#  team            :integer
#  date_played     :date
#

class MatchStat < ActiveRecord::Base
  attr_accessible :match_id, :user_id, :match_number
  
  # TODO add index on user_id and match_id
  # Setting up the has_many through relationship
  belongs_to :user
  belongs_to :match

  TOKEN = "VSCSVSL01BZWF5F4"

  #validates :user_id, presence: true
  #validates :match_id, presence: true

  # Takes in a hash of all of the stats for a given account for a given game
  # parses the hash and sets the fields of this matchstat object
  #
  # returns "duplicate" if the matchstat object is a duplicate
  # 	true if the matchstat is saved properly
  # 	false if there's an error
  def fill_stats(raw_hash)
    logger.debug("************** building match_stats with raw_hash: #{raw_hash}")
    stats_hash = {:win => raw_hash["wins"].to_i,
                  :hero_id => raw_hash["hero_id"].to_i,
                  :team => raw_hash["team"].to_i,
                  :position => raw_hash["position"].to_i,
                  :hero_kills => raw_hash["herokills"].to_i,
                  :deaths => raw_hash["deaths"].to_i,
                  :hero_assists => raw_hash["heroassists"].to_i,
                  :level => raw_hash["level"].to_i,
                  :item_1 => raw_hash["slot_1"].to_i,
                  :item_2 => raw_hash["slot_2"].to_i,
                  :item_3 => raw_hash["slot_3"].to_i,
                  :item_4 => raw_hash["slot_4"].to_i,
                  :item_5 => raw_hash["slot_5"].to_i,
                  :item_6 => raw_hash["slot_6"].to_i,
                  :rating_change => raw_hash["amm_team_rating"].to_f,
                  :gold_lost_death => raw_hash["goldlost2death"].to_i,
                  :secs_dead => raw_hash["secs_dead"].to_i,
                  :hero_dmg => raw_hash["herodmg"].to_i,
                  :hero_kill_exp => raw_hash["heroexp"].to_i,
                  :hero_kill_gold => raw_hash["herokillsgold"].to_i,
                  :creep_kills => raw_hash["teamcreepkills"].to_i,
                  :creep_dmg => raw_hash["teamcreepdmg"].to_i,
                  :creep_exp => raw_hash["teamcreepexp"].to_i,
                  :creep_gold => raw_hash["teamcreepgold"].to_i,
                  :neutral_kills => raw_hash["neutralcreepkills"].to_i,
                  :neutral_dmg => raw_hash["teamcreepdmg"].to_i,
                  :neutral_exp => raw_hash["neutralcreepexp"].to_i,
                  :neutral_gold => raw_hash["neutralcreepgold"].to_i,
                  :building_dmg => raw_hash["bdmg"].to_i,
                  :building_gold => raw_hash["bgold"].to_i,
                  :denies => raw_hash["denies"].to_i,
                  :exp_denied => raw_hash["exp_denied"].to_i,
                  :gold => raw_hash["gold"].to_i,
                  :gold_spent => raw_hash["gold_spent"].to_i,
                  :exp => raw_hash["exp"].to_i,
                  :actions => raw_hash["actions"].to_i,
                  :secs => raw_hash["secs"].to_i,
                  :consumables => raw_hash["consumables"].to_i,
                  :wards => raw_hash["wards"].to_i,
                  :nickname => raw_hash["nickname"],
                  :hon_id => raw_hash["account_id"].to_i,
                  :match_number => raw_hash["match_id"].to_i}
    return "duplicate" if MatchStat.where("hon_id = ? AND match_number = ?", stats_hash[:hon_id], stats_hash[:match_number]).any?
    stats_hash.each_key {|field| self.send("#{field}=", stats_hash[field])}
    user = User.find_by_hon_id(self.hon_id)
    uid = user.id if user
    self.user_id = uid if uid and !self.user_id
    return self.save
    
  end

  def self.build_update_user(usr)
    # TODO make this fail more gracefully.  If can't save, remember it for later
    # Find all the match_stats we've created for this user previously and assoc
    # to their user id. We don't have to worry about creating these matches
    existing_match_numbers = []
    existing_statlines = MatchStat.where(hon_id: usr.hon_id)
    existing_statlines.each do |statline|
      statline.user_id = usr.id
      statline.save
      existing_match_numbers << statline.match_number
    end
    # now create the stats for the last 25 games for this user.
    full_history = MatchStat.match_history_for(usr.nickname)          #returns an array whose 0th element is a comma-separated string of all matches played since 2011
    history_split = full_history[0]["history"].split(',') #separate the matches, which are further separated into "<match-id>| 2 | <date>"
    # TODO can get the date from here. Maybe make this into an array with key being matchnum and val being date?
    # TODO implement version which will look for the 25 most recent matches that haven't already been created
    #arr_25 = history_split.reduce([]) {|ary, match| ary << match.split('|')[0] unless existing_match_numbers.include?(match.split('|')[0])} #takes all of the matches and selects only the match_id (format: match_id | date | something)
    #history_hash = history_split.reduce({}) {|hsh, mtch| hsh[(mtch.split('|')[0])] = (mtch.split('|')[1])}#Date.strptime(match.split('|')[1], "%m/%d/%y")}
    arr_25 = []
    history_split.each do |mtch|
      arr_25 << (mtch.split('|')[0])
    end
    arr_25 = arr_25.select {|candidate| !(existing_match_numbers.include?(candidate))}
    arr_25 = arr_25[-25,25] if arr_25.size >= 25
    recent_string_25 = arr_25.join("+")
    multimatch_raw = MatchStat.multimatch_stats(recent_string_25)
    MatchStat.parse_and_create_match(multimatch_raw)
  end

  # TODO get this working
  # takes in an array of matchstats and builds the matches and matchstats for them
  def self.parse_and_create_match(matchstats)
    #@processed = []
    #logger.debug "Matchstats[1]: #{matchstats[1]}"
    match_datetimes = {}
    matchstats[-1].each {|summary| match_datetimes[summary["match_id"]] = DateTime.strptime(summary["mdt"], "%Y-%m-%d %H:%M:%S")}
  
    matchstats[1].each do |stats|
      matchstats[2].each do |part|
        if part["account_id"] == stats["account_id"] and part["match_id"] == stats["match_id"]
          @statline = stats.merge(part)
          #@processed << stats.dup
          #@statline = stats.dup
          match = Match.where(:match_number => @statline["match_id"].to_i).first_or_create(:duration_seconds => @statline["secs"].to_i, 
                              :winner => (((@statline["wins"].to_i) + (@statline["team"]).to_i)%2 +1), :date_played => match_datetimes[@statline["match_id"]])
          ms = match.match_stats.build
          ms.date_played = match.date_played
          ms.fill_stats(@statline)
          #my_proc.call(ms)
        end
      end
    end
    
  end

  def recent_game_stats_for(usr)
    #refined = []
    processed = []
    begin
      #processed = []
      account_id = usr.hon_id     #TODO make this better.  Use user id for everything.
  
      multimatch_raw = multimatch_stats(recent_string_25)
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

  def self.match_history_for(nick)
    logger.debug "**************entering api caller with vars: #{nick} and #{Rails.application.config.hon_api_token}"
    json = open "http://api.heroesofnewerth.com/match_history/ranked/nickname/#{nick}/?token=#{Rails.application.config.hon_api_token}", proxy: Rails.application.config.proxy_url
    return JSON.parse(json.read)
  end

  def self.multimatch_stats(matchId)
    logger.debug "**************entering api caller with vars: #{matchId} and #{Rails.application.config.hon_api_token}"
    json = open "http://api.heroesofnewerth.com/multi_match/all/matchids/#{matchId}/?token=#{Rails.application.config.hon_api_token}", proxy: Rails.application.config.proxy_url
    return JSON.parse(json.read)
  end

  def gpm
    return ((self.gold.to_f/self.secs.to_f)*60).round(2)
  end
  def apm
    return ((self.actions.to_f/self.secs.to_f)*60).round(2)
  end
end
