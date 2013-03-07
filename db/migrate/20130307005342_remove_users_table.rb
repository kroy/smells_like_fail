class RemoveUsersTable < ActiveRecord::Migration
  def up
  	drop_table :users
    drop_table :comments
    drop_table :games
  end

  def down
  end
end
