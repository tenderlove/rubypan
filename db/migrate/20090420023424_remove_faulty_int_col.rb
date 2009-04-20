class RemoveFaultyIntCol < ActiveRecord::Migration
  def self.up
    remove_column :ratings, :integer
  end

  def self.down
  end
end
