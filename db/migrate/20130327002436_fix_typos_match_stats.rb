class FixTyposMatchStats < ActiveRecord::Migration
  def change
  	rename_column :match_stats, :positon, :position
  	rename_column :match_stats, :gold_lost_deat, :gold_lost_death
  end
end
