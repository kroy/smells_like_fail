class RecreateTables < ActiveRecord::Migration
  def change
  	create_table "events", :force => true do |t|
	    t.integer  "match_id"
	    t.integer  "match_number"
	    t.string   "event_type"
	    t.integer  "time"
	    t.integer  "x"
	    t.integer  "y"
	    t.integer  "z"
	    t.integer  "player"
	    t.integer  "team"
	    t.integer  "source"
	    t.decimal  "gold"
	    t.decimal  "exp"
	    t.string   "extra_params"
	    t.datetime "created_at",   :null => false
	    t.datetime "updated_at",   :null => false
	    t.string   "nickname"
	end

	create_table "match_stats", :force => true do |t|
	    t.integer  "user_id"
	    t.integer  "match_id"
	    t.datetime "created_at",      :null => false
	    t.datetime "updated_at",      :null => false
	    t.integer  "hero_id"
	    t.integer  "position"
	    t.integer  "hero_kills"
	    t.integer  "deaths"
	    t.integer  "hero_assists"
	    t.integer  "level"
	    t.integer  "item_1"
	    t.integer  "item_2"
	    t.integer  "item_3"
	    t.integer  "item_4"
	    t.integer  "item_5"
	    t.integer  "item_6"
	    t.float    "rating_change"
	    t.integer  "gold_lost_death"
	    t.integer  "secs_dead"
	    t.integer  "hero_dmg"
	    t.integer  "hero_kill_exp"
	    t.integer  "hero_kill_gold"
	    t.integer  "creep_kills"
	    t.integer  "creep_dmg"
	    t.integer  "creep_exp"
	    t.integer  "creep_gold"
	    t.integer  "neutral_kills"
	    t.integer  "neutral_dmg"
	    t.integer  "neutral_exp"
	    t.integer  "neutral_gold"
	    t.integer  "building_dmg"
	    t.integer  "building_gold"
	    t.integer  "denies"
	    t.integer  "exp_denied"
	    t.integer  "gold"
	    t.integer  "gold_spent"
	    t.integer  "exp"
	    t.integer  "actions"
	    t.integer  "secs"
	    t.integer  "consumables"
	    t.integer  "wards"
	    t.string   "combo_kill"
	    t.string   "ks"
	    t.integer  "match_number"
	    t.string   "nickname"
	    t.integer  "hon_id"
	    t.integer  "win"
	    t.integer  "team"
	    t.datetime "date_played"
	end

	create_table "matches", :force => true do |t|
	    t.datetime "date_played"
	    t.integer  "duration_seconds"
	    t.datetime "created_at",       :null => false
	    t.datetime "updated_at",       :null => false
	    t.integer  "match_number"
	    t.integer  "winner"
	end

	create_table "users", :force => true do |t|
	    t.string   "nickname"
	    t.datetime "created_at",              :null => false
	    t.datetime "updated_at",              :null => false
	    t.integer  "games_played"
	    t.integer  "wins"
	    t.integer  "losses"
	    t.integer  "kills"
	    t.integer  "deaths"
	    t.integer  "assists"
	    t.integer  "secs"
	    t.integer  "secs_dead"
	    t.float    "avg_hero_damage"
	    t.float    "avg_exp"
	    t.integer  "gold"
	    t.float    "avg_gold_from_hero_kill"
	    t.float    "avg_gold_lost_deaths"
	    t.float    "avg_creep_kills"
	    t.float    "avg_creep_exp"
	    t.float    "avg_creep_gold"
	    t.float    "avg_neutral_kills"
	    t.float    "avg_neutral_exp"
	    t.float    "avg_neutral_gold"
	    t.float    "avg_building_gold"
	    t.float    "avg_wards"
	    t.float    "mmr"
	    t.float    "avg_denies"
	    t.integer  "last_match"
	    t.integer  "hon_id"
	    t.datetime "last_refreshed"
	end
  end
end
