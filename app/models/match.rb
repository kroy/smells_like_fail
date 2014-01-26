# == Schema Information
#
# Table name: matches
#
#  id               :integer          not null, primary key
#  date_played      :datetime
#  duration_seconds :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  match_number     :integer
#  winner           :integer
#

require 'zip'
require 'net/http'
require 'open-uri'

class Match < ActiveRecord::Base
  # TODO figure out which attributes should be accessible
  attr_accessible :date_played, :duration_seconds, :match_number, :winner, :replay_url

  has_many :users, :through => :match_stats
  has_many :match_stats
  has_many :events

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

  def initialize_from_api

  end

  def initialize_from_log
  	logfile = get_log
  	logger.debug("*************Initializing match properties. Seeking to the end")
	line = logfile.readline
	logger.debug("*************Got match-end line: #{line.inspect}")
	#line.encode!("UTF-8", "UTF-16le", :invalid => :replace, :undefined => :replace, replace: "", universal_newline: true)
	#line.encode!("UTF-8", "UTF-8", :invalid => :replace, :undefined => :replace, replace: "")
	#ewwww fix this
	pieces = line.scan(/(?:"(?:\\.|[^"])*"|[^" ])+/)
	logger.debug("******************pieces: #{pieces}")
	params = parse_params(pieces[1..-1]) if pieces.length > 0
	# duration_secs = params[:time].to_i/1000 if params[:time]
	# winner = params[:winer].to_i if params[:winner]
	# logfile.rewind
	pieces = logfile.readline.scan(/(?:"(?:\\.|[^"])*"|[^" ])+/)
	params = parse_params(pieces[1..-1]) if pieces.length > 0
	date_played = Date.strptime(params[:date], "%Y/%d/%m") if params[:date]
	# self.duration_seconds = duration_secs
	# self.winner = winner
	# self.date_played = date_played
	return logfile
  end

  # TODO: periodic gold, items, runes, kongor, killstreaks

  def parse_events(logfile=nil)
  	unless logfile
  		logfile = get_log
  	end
  	
  	players = {}
  	logfile.each do |line|
  		logger.debug("*********Parsing line: #{line.strip}")
  		pieces = line.scan(/(?:"(?:\\.|[^"])*"|[^" ])+/)
		params = parse_params(pieces[1..-1]) if pieces.size>=1
		ev = self.events.build
		ev.match_number = self.match_number
		case pieces[0] 
		when "PLAYER_CONNECT"
			players[params[:player]] = {nickname: params[:name], id: params[:id], psr: params[:psr]}
		when "PLAYER_TEAM_CHANGE"
			players[params[:player]][:team] = params[:team]
		when "PLAYER_SELECT", "PLAYER_RANDOM"
			ev.build_event("player", params, players)
		when "PLAYER_CHAT"
			ev.build_event("chat", params, players)
		when "GOLD_EARNED"
			ev.build_event("gold_earned", params, players)
		when "EXP_EARNED"
			ev.build_event("exp_earned", params, players)
		when "HERO_DEATH", "HERO_ASSIST"
			self.parse_death(pieces, params, players, logfile)
		when "GAME_CONCEDE", "GAME_END"
			#need to remove this logic once I get API access again
			self.winner = params[:winner].to_i
			self.duration_seconds = params[:time].to_i/1000
			ev.build_event("game_end", params, players)
		end	
  	end
  end

  def get_log
  	logger.debug("**************Before getting the initial resp for #{self.match_number}")
	log_url = self.replay_url
	unless log_url
		url = "http://replaydl.heroesofnewerth.com/replay_dl.php?file=&match_id=" + self.match_number.to_s
		resp = Net::HTTP.get_response(URI(url))
		logger.debug("**************Got the resp: #{resp.to_hash}")
		log_url = resp.to_hash["location"][0]
	end
	log_url = log_url[0..-10] + "zip"
	#Change the path of the zip files
	fpath = Rails.root.join('tmp', 'tst.zip')
	open(fpath, 'wb') do |file|
		file << open(log_url).read
		logger.debug("**************Got zip file")
	end
	logfilepath = Rails.root.join('tmp', 'tmp.log')
	Zip::File.open(fpath) do |zipfile|
		zipfile.each do |file|	
			#logfilepath.join(file.to_s)
			file.extract(logfilepath){true}
			logger.debug("**************Opened the zipfile")
		end
	end
	logfile = open(logfilepath.to_s, "rb:UTF-16le")

	return logfile
  end

  def parse_death(pieces, params, players, logfile)
  	logger.debug("********** Entering parse_death with line: #{pieces}")
  	assists = {}
  	kill = {}
  	death = {}
  	last_line_seen = false
  	line = ""
  	while(!last_line_seen)
	  	ev = self.events.build
	  	ev.match_number = self.match_number
		case pieces[0]
		when "HERO_ASSIST"
			assists[params[:player]] = params.dup
			logger.debug("********** So far, have assists for: #{assists.keys}")
		when "HERO_DEATH"
			death[params[:player]] = params.dup
		when "KILL"
			kill[params[:player]] = params.dup
		when "GOLD_EARNED"
			if assists[params[:player]] && assists[params[:player]][:gold] 
				assists[params[:player]][:gold] = (assists[params[:player]][:gold].to_d + params[:gold].to_d).to_s
			elsif assists[params[:player]]
				assists[params[:player]][:gold] = params[:gold]
			elsif kill[params[:player]]
				kill[params[:player]][:gold] = params[:gold]
			end
			ev.build_event("gold_earned", params, players)
		when "EXP_EARNED"
			logger.debug("********** So far, have assists for: #{assists.keys}")
			logger.debug("********** So far, have kills for: #{kill.keys}")			
			if kill[params[:player]]
				kill[params[:player]][:experience] = params[:experience]
			elsif assists[params[:player]]
				assists[params[:player]][:experience] = params[:experience]
			end
			ev.build_event("exp_earned", params, players)
		when "DAMAGE"
			#need to be careful with this. Damage line doesn't contain time param
		when "AWARD_KILL_STREAK"
			ev.build_event("kill_streak", params, players)
		when "GOLD_LOST"
			logger.debug("********** So far, have death for: #{death.keys}")
			death[params[:player]][:gold] = params[:gold] if death[params[:player]]
			ev.build_event("hero_death", death[params[:player]], players)
			#should also add a  gold_lost event
			last_line_seen = true
		end
  		unless last_line_seen
  			line = logfile.readline
  			logger.debug("*********Parsing line: #{line.strip}")
  			pieces = line.scan(/(?:"(?:\\.|[^"])*"|[^" ])+/)
			params = parse_params(pieces[1..-1]) if pieces.size>=1
		end
  	end
  	logger.debug("********** Assists: #{assists}")
	logger.debug("********** Kill: #{kill}")
	assists.each_value do |assist|
		logger.debug("********** Parsing assist: #{assist}")
		ev = self.events.build()
		ev.match_number = self.match_number
		ev.build_event("assist", assist, players)
	end
	kill.each_value do |k|
		logger.debug("********** Parsing kill: #{k}")
		ev = self.events.build()
		ev.match_number = self.match_number
		ev.build_event("hero_kill", k, players)
	end
  	logger.debug("*********** Leaving parse_death method")
  end

  # might want to enable users to see the cs for each player
  def gold_snapshots(start_time=0, end_time, player) #should do this during event parsing
  	logger.debug("************ Building gold snaps for player #{player} between #{start_time}s and #{end_time}s")
  	gold_earned = self.events.where("event_type IN (?) AND player=? AND time>=? AND time<=?", ["GOLD_EARNED", "HERO_DEATH"], player, start_time*1000, end_time*1000).order('time ASC')
	gold_snapshots = {}
	gold_earned.each do |g|
		slot = (g.time/10000).to_s
		unless gold_snapshots[slot]
			 #might be better to do this with arrays
			gold_snapshots[slot] = {creeps: 0, neutrals:0, ancients: 0, heroes: 0, buildings: 0, gold_lost: 0}
		end
		if g.event_type == "HERO_DEATH"
			gold_snapshots[slot][:gold_lost] += g.gold.to_f
		elsif g.source == 20 || g.source == 22
			gold_snapshots[slot][:creeps] += g.gold.to_f
		elsif g.source == 21 || g.source == 23
			gold_snapshots[slot][:buildings] += g.gold.to_f
		elsif g.source == 24
			gold_snapshots[slot][:ancients] += g.gold.to_f
		elsif g.source == 25
			gold_snapshots[slot][:neutrals] += g.gold.to_f
		else
			gold_snapshots[slot][:heroes] += g.gold.to_f
		end
	end
	return gold_snapshots
  end

  def exp_snapshots(start_time=0, end_time, player) #should do this during event parsing
  	logger.debug("************ Building gold snaps for player #{player} between #{start_time}s and #{end_time}s")
  	gold_earned = self.events.where("event_type IN (?) AND player=? AND time>=? AND time<=?", ["GOLD_EARNED", "HERO_DEATH"], player, start_time*1000, end_time*1000).order('time ASC')
	gold_snapshots = {}
	gold_earned.each do |g|
		slot = (g.time/10000).to_s
		unless gold_snapshots[slot]
			 #might be better to do this with arrays
			gold_snapshots[slot] = {creeps: 0, neutrals:0, ancients: 0, heroes: 0, buildings: 0, gold_lost: 0}
		end
		if g.event_type == "HERO_DEATH"
			gold_snapshots[slot][:gold_lost] += g.gold.to_f
		elsif g.source == 20 || g.source == 22
			gold_snapshots[slot][:creeps] += g.gold.to_f
		elsif g.source == 21 || g.source == 23
			gold_snapshots[slot][:buildings] += g.gold.to_f
		elsif g.source == 24
			gold_snapshots[slot][:ancients] += g.gold.to_f
		elsif g.source == 25
			gold_snapshots[slot][:neutrals] += g.gold.to_f
		else
			gold_snapshots[slot][:heroes] += g.gold.to_f
		end
	end
	return gold_snapshots
  end

  def parse_params(raw)
  	params = {}
	raw.each do |param|
		params[param.split(":")[0].intern]=param.split(":")[1].tr("\"", "").strip
	end

	return params
  end
end
