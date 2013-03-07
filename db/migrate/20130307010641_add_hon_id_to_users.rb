class AddHonIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :hon_id, :string
  end
end
