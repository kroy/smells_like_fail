<<<<<<< HEAD
# == Schema Information
#
# Table name: matches
#
#  id               :integer          not null, primary key
#  match_id         :string(255)
#  date_played      :date
#  duration_seconds :integer
#  winner           :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

=======
>>>>>>> updating-users
class Match < ActiveRecord::Base
  # TODO figure out which attributes should be accessible
  attr_accessible :date_played, :duration_seconds, :match_id, :winner

  has_many :users, :through => :match_stats
end
