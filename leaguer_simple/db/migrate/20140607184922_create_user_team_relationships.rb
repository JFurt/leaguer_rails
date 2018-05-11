class CreateUserTeamRelationships < ActiveRecord::Migration
  def change
    create_table :user_team_relationships do |t|
      t.integer :user_id
      t.integer :team_id
      t.boolean :captain, default: false
      t.integer :games_played, defalt: 0

      t.timestamps
    end
  end
end
