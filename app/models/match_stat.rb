# == Schema Information
#
# Table name: match_stats
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  match_id       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  win            :boolean
#  hero_id        :integer
#  team           :boolean
#  positon        :integer
#  hero_kills     :integer
#  deaths         :integer
#  hero_assists   :integer
#  level          :integer
#  item_1         :integer
#  item_2         :integer
#  item_3         :integer
#  item_4         :integer
#  item_5         :integer
#  item_6         :integer
#  rating_change  :float
#  gold_lost_deat :integer
#  secs_dead      :integer
#  hero_dmg       :integer
#  hero_kill_exp  :integer
#  hero_kill_gold :integer
#  creep_kills    :integer
#  creep_dmg      :integer
#  creep_exp      :integer
#  creep_gold     :integer
#  neutral_kills  :integer
#  neutral_dmg    :integer
#  neutral_exp    :integer
#  netural_gold   :integer
#  building_dmg   :integer
#  building_gold  :integer
#  denies         :integer
#  exp_denied     :integer
#  gold           :integer
#  gold_spent     :integer
#  exp            :integer
#  actions        :integer
#  secs           :integer
#  consumables    :integer
#  wards          :integer
#  combo_kill     :string(255)
#  ks             :string(255)
#

class MatchStat < ActiveRecord::Base
  attr_accessible #:match_id, :user_id
  
  # TODO add index on user_id and match_id
  # Setting up the has_many through relationship
  belongs_to :user
  belongs_to :match

  validates :user_id, presence: true
  validates :match_id, presence: true
end
