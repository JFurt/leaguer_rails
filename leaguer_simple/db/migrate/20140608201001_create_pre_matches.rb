class CreatePreMatches < ActiveRecord::Migration
  def change
    create_table :pre_matches do |t|
      t.integer :team_1_id
      t.integer :team_2_id

      t.timestamps
    end
    add_index :pre_matches , [:team_1_id, :team_2_id], unique: true
  end
end
