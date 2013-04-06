# == Schema Information
#
# Table name: users
#
#  id                      :integer          not null, primary key
#  nickname                :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  hon_id                  :string(255)
#  games_played            :integer
#  wins                    :integer
#  losses                  :integer
#  kills                   :integer
#  deaths                  :integer
#  assists                 :integer
#  secs                    :integer
#  secs_dead               :integer
#  avg_hero_damage         :float
#  avg_exp                 :float
#  gold                    :integer
#  avg_gold_from_hero_kill :float
#  avg_gold_lost_deaths    :float
#  avg_creep_kills         :float
#  avg_creep_exp           :float
#  avg_creep_gold          :float
#  avg_neutral_kills       :float
#  avg_neutral_exp         :float
#  avg_neutral_gold        :float
#  avg_building_gold       :float
#  avg_wards               :float
#  mmr                     :float
#  avg_denies              :float
#

class User < ActiveRecord::Base
  TOKEN = "KSXOOT43JUQJ2RQM"
  # TODO determine if I have to remove these fields from attr_accessible
  attr_accessible :nickname,:hon_id #,:email

  has_many :match_stats
  has_many :matches, :through => :match_stats

  #before_save { |user| user.email = email.downcase }
  before_save { |user| user.nickname = nickname.downcase }
  before_save { |user| user.hon_id = hon_id.downcase }

  #VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :nickname, presence: true, length: { maximum: 50 },
  			uniqueness: { case_sensitive: false }
  #validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
  			#uniqueness: { case_sensitive: false }
  validates :hon_id, presence: true, uniqueness: { case_sensitive: false } #also add length validator.  Potentially make this primary key

  ##   Helper Methods   ##

  # TODO Add logic to only automatically refresh if requested or if the stats are more than x hrs old
  # TODO add error handling from acct_stats_fetch
  # TODO fix this so that I can add a new user without saving the stats
  def stats_returner(refresh)
    returner = nil
    stats = {}
    if refresh
      stats = acct_stats_fetch(self.nickname)
      returner = stats
    end
    unless refresh or returner
      begin
        returner = {"hon_id" =>self.hon_id, "mmr"=>self.mmr, "games_played" => self.games_played, "wins"=>self.wins, "losses"=>self.losses, "kills"=>self.kills, 
                      "deaths"=>self.deaths, "assists"=>self.assists, "secs"=>self.secs, "secs_dead"=>self.secs_dead, "avg_hero_damage"=>self.avg_hero_damage,
                      "avg_exp"=>self.avg_exp, "gold"=>self.gold, "avg_gold_from_hero_kill"=>self.avg_gold_from_hero_kill,
                      "avg_gold_lost_deaths"=>self.avg_gold_lost_deaths, "avg_creep_kills"=>self.avg_creep_kills, "avg_creep_exp"=>self.avg_creep_exp,
                      "avg_creep_gold"=>self.avg_creep_gold, "avg_neutral_kills"=>self.avg_neutral_kills, "avg_neutral_exp"=>self.avg_neutral_exp,
                      "avg_neutral_gold"=>self.avg_neutral_gold, "avg_building_gold"=>self.avg_building_gold, "avg_wards"=>self.avg_wards,
                      "avg_denies"=>self.avg_denies}
      rescue
        returner = false
      end
    end
    return returner
  end

  def acct_stats_fetch(nick)
    # TODO add error handling
    begin
        json = open "http://api.heroesofnewerth.com/player_statistics/ranked/nickname/#{nick}/?token=#{TOKEN}"
        unfiltered = JSON.parse(json.read)
        
        filtered = {}

        #   Populate the hash to be returned to the view
        #
        numgames = unfiltered["rnk_games_played"].to_i
        filtered["hon_id"] = unfiltered["account_id"]
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
    rescue
        return false
    end
  end
end
