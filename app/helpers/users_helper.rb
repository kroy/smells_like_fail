#@TODO: Add error checking

require 'open-uri'

module UsersHelper

	# 	Might need to move to appropriate place
	#
	TOKEN = "KSXOOT43JUQJ2RQM"

	# 	Method called by the users#show view which will return the account
	# 	stats for the provided nickname
	#
	def acct_stats_for(nick)
		unfiltered = acct_stats_req(nick)
		filtered = {}

		# 	Populate the array to be returned to the view
		# 	Eventually handle this with db populations/request
		#
		numgames = unfiltered["rnk_games_played"].to_i
		filtered["mmr"] = unfiltered["rnk_amm_team_rating"]
		filtered["account_id"] = unfiltered["account_id"]
		filtered["games_played"] = numgames
		filtered["wins"] = unfiltered["rnk_wins"]
		filtered["win_pct"] = (unfiltered["rnk_wins"].to_f/numgames *100).round(0)
		filtered["losses"] = unfiltered["rnk_losses"]
		filtered["loss_pct"] = (unfiltered["rnk_losses"].to_f/numgames *100).round(0)
		filtered["avg_hero_damage"] = (unfiltered["rnk_herodmg"].to_f/numgames).round(0)
		filtered["avg_exp"] = unfiltered["rnk_heroexp"].to_i/numgames
		filtered["avg_gold_from_hero_kill"] = unfiltered["rnk_herokillsgold"].to_i/numgames
		filtered["avg_gold_lost_deaths"] = unfiltered["rnk_goldlost2death"].to_i/numgames
		filtered["kills"] = unfiltered["rnk_herokills"]
		filtered["deaths"] = unfiltered["rnk_deaths"]
		filtered["assists"] = unfiltered["rnk_heroassists"]
		filtered["kdr"] = (unfiltered["rnk_herokills"].to_f/unfiltered["rnk_deaths"].to_f).round(3)
		filtered["kadr"] = ((unfiltered["rnk_herokills"].to_f + unfiltered["rnk_heroassists"].to_f)/unfiltered["rnk_deaths"].to_f).round(3)
		filtered["avg_secs_dead"] = unfiltered["rnk_secs_dead"].to_f/numgames
		filtered["pct_time_dead"] = ((unfiltered["rnk_secs_dead"].to_f/unfiltered["rnk_secs"].to_f) *100).round(3)
		filtered["avg_creep_kills"] = (unfiltered["rnk_teamcreepkills"].to_f/numgames).round(0)
		filtered["avg_creep_exp"] = (unfiltered["rnk_teamcreepexp"].to_f/numgames).round(0)
		filtered["avg_creep_gold"] = (unfiltered["rnk_teamcreepgold"].to_f/numgames).round(0)
		filtered["avg_neutral_kills"] = (unfiltered["rnk_teamcreepkills"].to_f/numgames).round(0)
		filtered["avg_neutral_exp"] = (unfiltered["rnk_teamcreepexp"].to_f/numgames).round(0)
		filtered["avg_neutral_gold"] = (unfiltered["rnk_teamcreepgold"].to_f/numgames).round(0)
		filtered["avg_building_gold"] = (unfiltered["rnk_bgold"].to_f/numgames).round(0)
		filtered["avg_gpm"] = ((unfiltered["rnk_gold"].to_f/unfiltered["rnk_secs"].to_f)*60.0).round(0)
		filtered["avg_denies"] = (unfiltered["rnk_denies"].to_f/numgames).round(0)
		filtered["avg_wards"] = (unfiltered["rnk_wards"].to_f/numgames).round(1)
		#filtered["pct_time_earning_exp"] = ((unfiltered["rnk_time_earning_exp"].to_f/unfiltered["rnk_secs"].to_f)*100).round(2) #fairly useless stat

		# 	leaving out kill streak data for now; not sure what I want to do with it

		return filtered
	end

	# 	a helper method that makes a request to the hon stats API and 
	# 	returns the parsed json object representing the user's account stats
	#
	def acct_stats_req(nick)
		json = open "http://api.heroesofnewerth.com/player_statistics/ranked/nickname/#{nick}/?token=#{TOKEN}"
		return JSON.parse(json.read)
	end

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
