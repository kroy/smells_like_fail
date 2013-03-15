# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130315030403) do

  create_table "users", :force => true do |t|
    t.string   "nickname"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.string   "hon_id"
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
  end

  add_index "users", ["hon_id"], :name => "index_users_on_hon_id", :unique => true
  add_index "users", ["nickname"], :name => "index_users_on_nickname", :unique => true

end
