# == Schema Information
#
# Table name: matches
#
#  id               :integer          not null, primary key
#  date_played      :date
#  duration_seconds :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  match_number     :integer
#  winner           :integer
#

class Match < ActiveRecord::Base
  # TODO figure out which attributes should be accessible
  attr_accessible :date_played, :duration_seconds, :match_number, :winner

  has_many :users, :through => :match_stats
  has_many :match_stats

  #TOKEN = "0WQJS7VTWA5PCNU1"

  def update_match_stats
  	#begin
	  	json = open "http://api.heroesofnewerth.com/match/all/matchid/#{self.match_number}/?token=#{Rails.application.config.hon_api_token}"
		raw_hash = JSON.parse(json.read)
		processed = raw_hash[1] #pull the inventory data from the stats hash
        raw_hash[2].each do |stats|
          processed.each do |part|
            if part.value?(stats["account_id"])
              part.merge!(stats)
            end
          end
	    end
		# TODO make this more efficient
		match_users = self.match_stats.select("hon_id")
		# have to process raw_hash a little to make sure it's in correct format
		new_users = processed.partition {|statline| match_users.include?(statline["account_id"].to_i)}
		# TODO make ms entries for new_users[1]
		new_users[1].each do |usr|
			ms = self.match_stats.build
			# TODO condense this into one call
			# This will be false if the matchstat fails to save
			ms.fill_stats(usr)
			#stats.each_key {|field| ms.send("#{field}=", stats[field])}
			# TODO add error handling
			#ms.save
		end
	#rescue
		#puts "User update failed for #{self.match_number}"
	#end
  end
end
