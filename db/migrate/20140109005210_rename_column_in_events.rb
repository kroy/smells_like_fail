class RenameColumnInEvents < ActiveRecord::Migration
  def change
  	rename_column :events, :match_num, :match_number
  end
end
