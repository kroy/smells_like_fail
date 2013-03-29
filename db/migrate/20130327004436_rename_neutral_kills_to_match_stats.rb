class RenameNeutralKillsToMatchStats < ActiveRecord::Migration
  def change
  	rename_column :match_stats, :netural_gold, :neutral_gold
  end
end
