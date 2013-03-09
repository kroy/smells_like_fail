#@TODO: Add error checking

require 'open-uri'

module UsersHelper

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
		json = open "http://api.heroesofnewerth.com/player_statistics/ranked/nickname/#{nick}/?token=KSXOOT43JUQJ2RQM"
		return JSON.parse(json.read)
	end
end
