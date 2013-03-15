class ChangeColumnMmrInUsers < ActiveRecord::Migration
  def up
  	change_column :users, :mmr, :float
  	add_column :users, :avg_denies, :float
  end

  def down
  	change_column :users, :mmr, :integer
  	remove_column :users, :avg_denies
  end
end
