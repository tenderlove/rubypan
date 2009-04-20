class AddNumVotesToReleases < ActiveRecord::Migration
  def self.up
    add_column :releases, :num_ratings, :integer
  end

  def self.down
    remove_column :releases, :num_ratings
  end
end
