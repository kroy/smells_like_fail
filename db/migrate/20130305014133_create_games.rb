class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :id
      t.string :user

      t.timestamps
    end
  end
end
