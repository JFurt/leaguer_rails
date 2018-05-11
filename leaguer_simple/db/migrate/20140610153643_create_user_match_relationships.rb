class CreateUserMatchRelationships < ActiveRecord::Migration
  def change
    create_table :user_match_relationships do |t|
      t.boolean :team_1
      t.integer :user_id
      t.references :matchable, polymorphic: true
      t.timestamps
    end
  end
end
