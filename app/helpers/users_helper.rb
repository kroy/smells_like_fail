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

	
end
