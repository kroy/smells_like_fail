class AddReplayUrlToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :replay_url, :string
  end
end
