class AddMmrToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mmr, :integer
  end
end
