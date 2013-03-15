class AddIndexToUserStats < ActiveRecord::Migration
  def change
  	add_index :user_stats, :user_id, unique: true
  end
end
