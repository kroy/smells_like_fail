class AddFieldsToUserStat < ActiveRecord::Migration
  def change
  	add_column :user_stats, :games_played, :integer
  	add_column :user_stats, :wins, :integer
  	add_column :user_stats, :losses, :integer
  	add_column :user_stats, :kills, :integer
  	add_column :user_stats, :deaths, :integer
  	add_column :user_stats, :assists, :integer
  	add_column :user_stats, :secs, :integer
  	add_column :user_stats, :secs_dead, :integer
  	add_column :user_stats, :avg_hero_damage, :float
  	add_column :user_stats, :avg_exp, :float
  	add_column :user_stats, :gold, :integer
  	add_column :user_stats, :avg_gold_from_hero_kill, :float
  	add_column :user_stats, :avg_gold_lost_deaths, :float
  	add_column :user_stats, :avg_creep_kills, :float
  	add_column :user_stats, :avg_creep_exp, :float
  	add_column :user_stats, :avg_creep_gold, :float
  	add_column :user_stats, :avg_neutral_kills, :float
  	add_column :user_stats, :avg_neutral_exp, :float
  	add_column :user_stats, :avg_neutral_gold, :float
  	add_column :user_stats, :avg_building_gold, :float
  	add_column :user_stats, :avg_wards, :float
  end
end
