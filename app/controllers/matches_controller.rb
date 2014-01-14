require 'zip'
require 'net/http'

# encoding: UTF-8

class MatchesController < ApplicationController
	#TOKEN = "KSXOOT43JUQJ2RQM"
	rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

	def show
		fpath = Rails.root.join('tmp', 'tst.zip')
		url = "http://replaydl.heroesofnewerth.com/replay_dl.php?file=&match_id="

		# Need to make this find more robust; account for requests to /matches/[match_id]
		@match = Match.where(match_number: params[:id]).first
		@match = Match.find(params[:id]) unless @match
		#@match = Match.new(match_number: params[:id]) unless @match
		@match_stats = @match.match_stats.order('position ASC')
		@players = @match.events.where(event_type: "PLAYER_PROFILE").order('player ASC')
		@post_mortems = @match.events.where( :event_type => ["HERO_KILL", "HERO_DEATH", "ASSIST"]).order('player ASC')
		#@player = false
		if @match_stats.size < 10
			update
			@match_stats = @match.match_stats.order('position ASC')
		end

		if !@players.any? && Rails.application.config.event_parsing_enabled
			@match.parse_events(nil)
			@players = @match.events.where(event_type: "PLAYER_PROFILE").order('player ASC')
		end

		if @match_stats.any?
			@highest_gpm = (@match_stats.max_by {|stat| stat.gold}).nickname
			@highest_wards = (@match_stats.max_by {|stat| stat.wards}).nickname
			
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
	end

	def update
		# TODO implement this
		# make request to hon api
		#json = open "http://api.heroesofnewerth.com/match/all/matchid/#{@match.match_number}/?token=#{TOKEN}"
		#@statshash = JSON.parse(json.read)
		@match.update_match_stats
	end

	def new
		@match = Match.new
	end

	def create
		begin
			logger.debug("*************************trying to create match with match_number #{params[:match][:match_number]}")
			@match = Match.new(match_number: params[:match][:match_number])
			logfile = @match.initialize_from_log
			if @match.save
				@match.parse_events(logfile)
				redirect_to match_path(@match.match_number) and return
			end
			render "new"
		rescue Exception => e
			#should close the file here
			logger.debug("*****************#{e}")
			redirect_to "/notfound"
		end
	end

	private

		def record_not_found
			redirect_to "new"
		end
end
