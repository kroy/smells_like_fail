require 'open-uri'

module UsersHelper
	def stats_for(nick)
		#test = open "http://api.heroesofnewerth.com/match_history/ranked/nickname/#{nick}/?token=KSXOOT43JUQJ2RQM"
		test = open("http://api.heroesofnewerth.com/hero_statistics/ranked/nickname/#{nick}/name/Behemoth?token=KSXOOT43JUQJ2RQM", "X-Forwarded-For" => "10.10.23.43")
		parsed = JSON.parse(test.read)
		#return parsed["account_id"]
		return parsed
	end
end
