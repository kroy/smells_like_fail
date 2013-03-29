class AddMatchNumberToMatchStats < ActiveRecord::Migration
  def change
    add_column :match_stats, :match_number, :integer
  end
end
