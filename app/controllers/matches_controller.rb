class MatchesController < ApplicationController
	TOKEN = "KSXOOT43JUQJ2RQM"
	def show
		@match = Match.find(params[:id])
		@match_stats = @match.match_stats.order('position ASC')
		@player = false
		if @match_stats.size < 10
			update
			@match_stats = @match.match_stats.order('position ASC')
		end
	end

	def update
		# TODO implement this
		# make request to hon api
		#json = open "http://api.heroesofnewerth.com/match/all/matchid/#{@match.match_number}/?token=#{TOKEN}"
		#@statshash = JSON.parse(json.read)
		@match.update_match_stats
	end
end
