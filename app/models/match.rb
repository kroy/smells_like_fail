class Match < ActiveRecord::Base
  # TODO figure out which attributes should be accessible
  attr_accessible :date_played, :duration_seconds, :match_id, :winner

  has_many :users, :through => :match_stats
end
