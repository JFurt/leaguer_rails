class AddAcceptedToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :challenged, :boolean, default: false
  end
end
