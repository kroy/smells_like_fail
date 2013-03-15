#@TODO: Add error checking

require 'open-uri'

module UsersHelper

	# 	Might need to move to appropriate place
	#
	TOKEN = "KSXOOT43JUQJ2RQM"

	def acct_stats_id_req(honId)
		json = open "http://api.heroesofnewerth.com/player_statistics/all/accountid/211652/?token=#{TOKEN}"
		#json = open "http://api.heroesofnewerth.com/account/id/211652"
		return JSON.parse(json.read)
	end

	# 	Returns the last 25 matches this player has played
	# 	TODO: Check for errors eg if the player has fewer than 25 matches
	# 		Potentially have these methods take in the user obj
	#
	def recent_game_stats_for(nick)
		account_id = User.find_by_nickname(nick).hon_id 		#TODO make this better.  Use user id for everything.
		full_history = match_history_for(nick) 					#returns an array whose 0th element is a comma-separated string of all matches played since 2011
		history_split = full_history[0]["history"].split(',')	#separate the matches, which are further separated into "<match-id>| 2 | <date>"
		recent_string_25 = history_split[-25].split('|')[0] 	#string of the last 25 match ids separated by a "+"
		history_split[-24,24].each do |frag|
			recent_string_25 << "+" << frag.split('|')[0]
		end
		multimatch_raw = match_stats_multimatch_for(recent_string_25)
		processed = []
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
		#return slot
		return processed
	end

	def match_history_for(nick)
		json = open "http://api.heroesofnewerth.com/match_history/ranked/nickname/#{nick}/?token=#{TOKEN}"
		return JSON.parse(json.read)
	end

	def match_stats_summary_for(matchId)
		json = open "http://api.heroesofnewerth.com/match/summ/matchid/#{matchId}/?token=#{TOKEN}"
		return JSON.parse(json.read)
	end

	def match_stats_all_for(matchId)
		json = open "http://api.heroesofnewerth.com/match/all/matchid/#{matchId}/?token=#{TOKEN}"
		return JSON.parse(json.read)
	end

	def match_stats_statistics_for(matchId)
		json = open "http://api.heroesofnewerth.com/match/statistics/matchid/#{matchId}/?token=#{TOKEN}"
		return JSON.parse(json.read)
	end

	def match_stats_multimatch_for(matchId)
		json = open "http://api.heroesofnewerth.com/multi_match/all/matchids/#{matchId}/?token=#{TOKEN}"
		return JSON.parse(json.read)
	end
end
