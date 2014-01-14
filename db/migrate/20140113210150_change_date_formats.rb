class ChangeDateFormats < ActiveRecord::Migration
  def up
  	change_column :matches, :date_played, :datetime
  	change_column :match_stats, :date_played, :datetime
  end

  def down
  	change_column :matches, :date_played, :date
  	change_column :match_stats, :date_played, :date
  end
end
