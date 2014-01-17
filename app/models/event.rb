# == Schema Information
#
# Table name: events
#
#  id           :integer          not null, primary key
#  match_id     :integer
#  match_number :integer
#  event_type   :string(255)
#  time         :integer
#  x            :integer
#  y            :integer
#  z            :integer
#  player       :integer
#  team         :integer
#  source       :integer
#  gold         :decimal(, )
#  exp          :decimal(, )
#  extra_params :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  nickname     :string(255)
#
require 'open-uri'


class Event < ActiveRecord::Base
  attr_accessible :match_id, :match_num, :time, :type, :x, :y, :z

  belongs_to :match

  def build_event(type, params, players)
  	begin
	  	logger.debug("************ Building an event of type #{type} with params: #{params}")
  	  if params[:player]
        self.player = params[:player].to_i
  	  	self.team = players[params[:player]][:team].to_i
  	  	self.nickname = players[params[:player]][:nickname]
      end
	  	params[:time]? self.time = params[:time].to_i : self.time = 0
	  	self.x = params[:x].to_i if params[:x]
	  	self.y = params[:y].to_i if params[:y]
	  	self.z = params[:z].to_i if params[:z]
	  	return self.send("build_#{type}".intern, params, players)
	  rescue Exception => e
  		logger.error("**********Error building event: #{e}")
  		return false
	  end
  end

  def build_player(params, players)
  	logger.debug("************ In the build player method #{players[params[:player]]}")
  	self.event_type = "PLAYER_PROFILE"
  	self.extra_params = "hero:#{params[:hero]}"
  	return self.save
  end

  def build_chat(params, players)
  	logger.debug("************ In the build chat method for #{players[params[:player]]}")
  	self.event_type = "CHAT"
  	#Should scrub the things I put in extra params
  	logger.debug("************ This person said '#{params[:msg]}")
  	self.extra_params = "target:#{params[:target]},msg:#{params[:msg]}"
  	return self.save
  end

  def build_hero_kill(params, players)
  	logger.debug("************ In the build hero_kill method for #{players[params[:player]]} with params: #{params}")
  	params[:source_name] = params[:target] if params[:target]
  	params[:owner]? params[:source] = params[:owner] : params[:source] = Event.parse_npc_source(params[:source])
  	self.event_type = "HERO_KILL"
  	self.gold = params[:gold].to_f
  	self.exp = params[:experience].to_f if params[:experience]
  	self.source = params[:source].to_i
  	self.extra_params = "source_name:#{params[:source_name]}"
  	return self.save
  end

  def build_hero_death(params, players)
  	logger.debug("************ In the build hero_death method for #{players[params[:player]]} with params: #{params}")
  	params[:source_name] = params[:attacker] if params[:attacker]
  	params[:owner]? params[:source] = params[:owner] : params[:source] = Event.parse_npc_source(params[:source])
  	self.event_type = "HERO_DEATH"
  	self.gold = params[:gold].to_f
  	self.source = params[:source].to_i
  	self.extra_params = "source_name:#{params[:source_name]}"
  	return self.save
  end

  def build_assist(params, players)
  	logger.debug("************ In the build assist method for #{players[params[:player]]} with params: #{params}")
  	params[:source_name] = params[:target] if params[:target]
  	params[:owner]? params[:source] = params[:owner] : params[:source] = Event.parse_npc_source(params[:source])
  	self.event_type = "ASSIST"
  	self.gold = params[:gold].to_f
  	self.exp = params[:experience].to_f if params[:experience]
  	self.source = params[:source].to_i
  	self.extra_params = "source_name:#{params[:source_name]}"
  	return self.save
  end
  
  def build_gold_earned(params, players)
  	logger.debug("************ In the build gold_earned method for #{players[params[:player]]} with params: #{params}")
  	params[:source_name] = params[:source] if params[:source]
	  params[:owner]? params[:source] = params[:owner] : params[:source] = Event.parse_npc_source(params[:source])
  	self.event_type = "GOLD_EARNED"
  	self.gold = params[:gold].to_f
  	self.source = params[:source].to_i
  	self.extra_params = "source_name:#{params[:source_name]}"
  	return self.save
  end

  def build_exp_earned(params, players)
  	logger.debug("************ In the build exp_earned method for #{players[params[:player]]}")
  	params[:source_name] = params[:source] if params[:source]
	  params[:owner]? params[:source] = params[:owner] : params[:source] = Event.parse_npc_source(params[:source])
  	self.event_type = "EXP_EARNED"
  	self.exp = params[:experience].to_d
  	self.source = params[:source].to_i
  	self.extra_params = "source_name:#{params[:source_name]}"
    return self.save
  end

  def build_game_end(params, players)
  	logger.debug("************ Game over: #{params}")
  	self.event_type = "GAME_END"
  	self.extra_params = "winner:#{params[:winner]}"
  	return self.save
  end

  def self.parse_npc_source(src)
  	return "20" if src.include?("Creep_Legion")
  	return "21" if src.include?("Creep_Hellbourne")
  	return "23" if src.include?("Neutral")
  end

end
