class AddAcceptedToUserTeamRelationship < ActiveRecord::Migration
  def change
    add_column :user_team_relationships, :accepted, :boolean, default: false
  end
end
