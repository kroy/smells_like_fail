class AddColumnsToMatchStats < ActiveRecord::Migration
  def change
    add_column :match_stats, :nickname, :string
    add_column :match_stats, :hon_id, :integer
    remove_column :match_stats, :win
    remove_column :match_stats, :team
    add_column :match_stats, :win, :integer
    add_column :match_stats, :team, :integer
  end
end
