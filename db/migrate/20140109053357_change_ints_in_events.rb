class ChangeIntsInEvents < ActiveRecord::Migration
  def up
  	change_column :events, :exp, :decimal
  	change_column :events, :gold, :decimal
  end

  def down
  	change_column :events, :exp, :integer
  	change_column :events, :gold, :integer
  end
end
