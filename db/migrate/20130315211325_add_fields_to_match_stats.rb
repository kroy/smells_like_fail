class AddFieldsToMatchStats < ActiveRecord::Migration
  def change
  	add_column :match_stats, :win, :boolean
  	add_column :match_stats, :hero_id, :integer
  	add_column :match_stats, :team, :boolean
  	add_column :match_stats, :positon, :integer
  	add_column :match_stats, :hero_kills, :integer
  	add_column :match_stats, :deaths, :integer
  	add_column :match_stats, :hero_assists, :integer
  	add_column :match_stats, :level, :integer
  	add_column :match_stats, :item_1, :integer
  	add_column :match_stats, :item_2, :integer
  	add_column :match_stats, :item_3, :integer
  	add_column :match_stats, :item_4, :integer
  	add_column :match_stats, :item_5, :integer
  	add_column :match_stats, :item_6, :integer
  	add_column :match_stats, :rating_change, :float
  	add_column :match_stats, :gold_lost_deat, :integer
  	add_column :match_stats, :secs_dead, :integer
  	add_column :match_stats, :hero_dmg, :integer
  	add_column :match_stats, :hero_kill_exp, :integer
  	add_column :match_stats, :hero_kill_gold, :integer
  	add_column :match_stats, :creep_kills, :integer
  	add_column :match_stats, :creep_dmg, :integer
  	add_column :match_stats, :creep_exp, :integer
  	add_column :match_stats, :creep_gold, :integer
  	add_column :match_stats, :neutral_kills, :integer
  	add_column :match_stats, :neutral_dmg, :integer
  	add_column :match_stats, :neutral_exp, :integer
  	add_column :match_stats, :netural_gold, :integer
  	add_column :match_stats, :building_dmg, :integer
  	add_column :match_stats, :building_gold, :integer
  	add_column :match_stats, :denies, :integer
  	add_column :match_stats, :exp_denied, :integer
  	add_column :match_stats, :gold, :integer
  	add_column :match_stats, :gold_spent, :integer
  	add_column :match_stats, :exp, :integer
  	add_column :match_stats, :actions, :integer
  	add_column :match_stats, :secs, :integer
  	add_column :match_stats, :consumables, :integer
  	add_column :match_stats, :wards, :integer
  	add_column :match_stats, :combo_kill, :string
  	add_column :match_stats, :ks, :string

  end
end
