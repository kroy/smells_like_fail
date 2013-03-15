class AddStatsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :games_played, :integer
  	add_column :users, :wins, :integer
  	add_column :users, :losses, :integer
  	add_column :users, :kills, :integer
  	add_column :users, :deaths, :integer
  	add_column :users, :assists, :integer
  	add_column :users, :secs, :integer
  	add_column :users, :secs_dead, :integer
  	add_column :users, :avg_hero_damage, :float
  	add_column :users, :avg_exp, :float
  	add_column :users, :gold, :integer
  	add_column :users, :avg_gold_from_hero_kill, :float
  	add_column :users, :avg_gold_lost_deaths, :float
  	add_column :users, :avg_creep_kills, :float
  	add_column :users, :avg_creep_exp, :float
  	add_column :users, :avg_creep_gold, :float
  	add_column :users, :avg_neutral_kills, :float
  	add_column :users, :avg_neutral_exp, :float
  	add_column :users, :avg_neutral_gold, :float
  	add_column :users, :avg_building_gold, :float
  	add_column :users, :avg_wards, :float
  end
end
