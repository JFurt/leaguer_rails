class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.integer :points, default: 0
      t.string :name


      t.timestamps
    end
  end
end
