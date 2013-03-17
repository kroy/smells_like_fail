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
  # TODO determine if I have to remove these fields from attr_accessible
  attr_accessible :nickname,:hon_id #,:email

  has_many :match_stats
  has_many :matches, :through => :match_stats
  #before_save { |user| user.email = email.downcase }
  before_save { |user| user.nickname = nickname.downcase }
  before_save { |user| user.hon_id = hon_id.downcase }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :nickname, presence: true, length: { maximum: 50 },
  			uniqueness: { case_sensitive: false }
  #validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
  			#uniqueness: { case_sensitive: false }
  validates :hon_id, presence: true, uniqueness: { case_sensitive: false } #also add length validator.  Potentially make this primary key

end
