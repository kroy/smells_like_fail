class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :match_id
      t.integer :match_num
      t.string :type
      t.integer :time
      t.integer :x
      t.integer :y
      t.integer :z
      t.integer :player
      t.integer :team
      t.integer :source
      t.integer :gold
      t.integer :exp
      t.string :extra_params

      t.timestamps
    end
  end
end
