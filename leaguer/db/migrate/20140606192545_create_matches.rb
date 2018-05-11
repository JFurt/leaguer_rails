class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :team_1_id
      t.integer :team_2_id
      t.boolean :team_1_won
      t.boolean :finished

      t.timestamps
    end
  end
end
