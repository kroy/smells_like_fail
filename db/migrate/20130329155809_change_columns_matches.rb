class ChangeColumnsMatches < ActiveRecord::Migration
  def up
  	remove_column :matches, :match_id
  	add_column :matches, :match_number, :integer
  	remove_column :matches, :winner
  	add_column :matches, :winner, :integer
  end

  def down
  	remove_column :matches, :match_number
  	add_column :matches, :match_id, :string
  	remove_column :matches, :winner
  	add_column :matches, :winner, :boolean
  end
end
