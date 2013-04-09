class AddDatePlayedToMatchStats < ActiveRecord::Migration
  def change
    add_column :match_stats, :date_played, :date
    add_column :users, :last_match, :integer
    remove_column :users, :hon_id
    add_column :users, :hon_id, :integer
  end
end
