# == Schema Information
#
# Table name: users
#
#  id                      :integer          not null, primary key
#  nickname                :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
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
#  last_match              :integer
#  hon_id                  :integer
#  last_refreshed          :datetime
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
