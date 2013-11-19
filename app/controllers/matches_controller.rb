class MatchesController < ApplicationController
	#TOKEN = "KSXOOT43JUQJ2RQM"
	rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

	def show
		@match = Match.find(params[:id])
		@match_stats = @match.match_stats.order('position ASC')
		#@player = false
		if @match_stats.size < 10
			update
			@match_stats = @match.match_stats.order('position ASC')
		end

		gon.players = @match_stats.reduce([]) {|coll, obj| coll << (obj.nickname)}
		gon.neut_gold = @match_stats.reduce([]) {|coll, obj| coll << (obj.neutral_gold/(obj.secs/60))}
		gon.hero_kill_gold = @match_stats.reduce([]) {|coll, obj| coll << (obj.hero_kill_gold/(obj.secs/60))}
		gon.creep_building_gold = @match_stats.reduce([]) {|coll, obj| coll << ((obj.creep_gold + obj.building_gold)/(obj.secs/60))}
		gon.hero_damage_done = @match_stats.reduce([]) {|coll, obj| coll << ([obj.nickname , if (obj.hero_dmg > 0) then obj.hero_dmg else 5 end])}
		gon.gold_lost_death = @match_stats.reduce([]) {|coll, obj| coll << (obj.gold_lost_death/(obj.secs/60))}
		exp_denied_legion = 0
		exp_denied_hellbourne = 0
		@match_stats.each {|obj| (if obj.team ==1 then exp_denied_legion+=obj.exp_denied else exp_denied_hellbourne+=obj.exp_denied end )}
		gon.exp_denied = [["Legion", exp_denied_legion], ["Hellbourne", exp_denied_hellbourne]]
	end

	def update
		# TODO implement this
		# make request to hon api
		#json = open "http://api.heroesofnewerth.com/match/all/matchid/#{@match.match_number}/?token=#{TOKEN}"
		#@statshash = JSON.parse(json.read)
		@match.update_match_stats
	end

	private

		def record_not_found
			redirect_to "/notfound"
		end
end
