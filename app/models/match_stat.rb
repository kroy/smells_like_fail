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
#

class MatchStat < ActiveRecord::Base
  attr_accessible :match_id, :user_id, :match_number
  
  # TODO add index on user_id and match_id
  # Setting up the has_many through relationship
  belongs_to :user
  belongs_to :match

  #validates :user_id, presence: true
  #validates :match_id, presence: true

  # Takes in a hash of all of the stats for a given account for a given game
  # parses the hash and sets the fields of this matchstat object
  #
  # returns "duplicate" if the matchstat object is a duplicate
  # 	true if the matchstat is saved properly
  # 	false if there's an error
  def fill_stats(raw_hash)
    refined = {:win => raw_hash["wins"].to_i, :hero_id => raw_hash["hero_id"].to_i, :team => raw_hash["team"].to_i, :position => raw_hash["position"].to_i, :hero_kills => raw_hash["herokills"].to_i,
              :deaths => raw_hash["deaths"].to_i, :hero_assists => raw_hash["heroassists"].to_i, :level => raw_hash["level"].to_i, :item_1 => raw_hash["slot_1"].to_i, 
              :item_2 => raw_hash["slot_2"].to_i,:item_3 => raw_hash["slot_3"].to_i, :item_4 => raw_hash["slot_4"].to_i, :item_5 => raw_hash["slot_5"].to_i, :item_6 => raw_hash["slot_6"].to_i,
              :rating_change => raw_hash["amm_team_rating"].to_f, :gold_lost_death => raw_hash["goldlost2death"].to_i, :secs_dead => raw_hash["secs_dead"].to_i, 
              :hero_dmg => raw_hash["hero_dmg"].to_i, :hero_kill_exp => raw_hash["heroexp"].to_i, :hero_kill_gold => raw_hash["herokillsgold"].to_i, 
              :creep_kills => raw_hash["teamcreepkills"].to_i, :creep_dmg => raw_hash["teamcreepdmg"].to_i, :creep_exp => raw_hash["teamcreepexp"].to_i, 
              :creep_gold => raw_hash["teamcreepgold"].to_i, :neutral_kills => raw_hash["neutralcreepkills"].to_i, :neutral_dmg => raw_hash["teamcreepdmg"].to_i, 
              :neutral_exp => raw_hash["neutralcreepexp"].to_i, :neutral_gold => raw_hash["neutralcreepgold"].to_i, :building_dmg => raw_hash["bdmg"].to_i, 
              :building_gold => raw_hash["bgold"].to_i, :denies => raw_hash["denies"].to_i, :exp_denied => raw_hash["exp_denied"].to_i, :gold => raw_hash["gold"].to_i,
              :gold_spent => raw_hash["gold_spent"].to_i, :exp => raw_hash["exp"].to_i, :actions => raw_hash["actions"].to_i, :secs => raw_hash["secs"].to_i, 
              :consumables => raw_hash["consumables"].to_i, :wards => raw_hash["wards"].to_i, :nickname => raw_hash["nickname"], :hon_id => raw_hash["account_id"].to_i, :match_number => raw_hash["match_id"].to_i}
    #if the 
    return "duplicate" if MatchStat.where("hon_id = ? AND match_number = ?", refined[:hon_id], refined[:match_number]).any?
    refined.each_key {|field| self.send("#{field}=", refined[field])}
    user = User.find_by_hon_id(self.hon_id)
    uid = user.hon_id if user
    self.user_id = uid if uid and !self.user_id
    return self.save
  end
end
