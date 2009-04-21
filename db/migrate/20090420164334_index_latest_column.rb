class IndexLatestColumn < ActiveRecord::Migration
  def self.up
    add_index(:releases, :latest)
  end

  def self.down
    remove_index(:releases, :column => :latest)
  end
end
