class AddAvgRatingToReleases < ActiveRecord::Migration
  def self.up
    add_column :releases, :avg_rating, :float
  end

  def self.down
    remove_column :releases, :avg_rating
  end
end
