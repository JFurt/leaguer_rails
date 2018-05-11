class ChangeMatches < ActiveRecord::Migration
  def change
    add_column :matches, :votes_team_2, :integer, default: 0
    add_column :matches, :votes_team_1, :integer, default: 0
    remove_column :matches, :challenged
  end
end
