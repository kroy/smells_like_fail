class CreateMatchStats < ActiveRecord::Migration
  def change
    create_table :match_stats do |t|
      t.integer :user_id
      t.integer :match_id

      t.timestamps
    end
  end
end
