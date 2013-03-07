class AddIndexToUsersNickname < ActiveRecord::Migration
  def change
  	add_index :users, :nickname, unique: true
  	add_index :users, :hon_id, unique: true
  end
end
