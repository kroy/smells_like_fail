class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.string :match_id
      t.date :date_played
      t.integer :duration_seconds
      t.boolean :winner

      t.timestamps
    end
  end
end
