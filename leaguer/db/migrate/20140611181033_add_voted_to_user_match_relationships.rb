class AddVotedToUserMatchRelationships < ActiveRecord::Migration
  def change
    add_column :user_match_relationships, :voted, :boolean, default: false
  end
end
