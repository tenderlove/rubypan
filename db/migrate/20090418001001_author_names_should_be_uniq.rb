class AuthorNamesShouldBeUniq < ActiveRecord::Migration
  def self.up
    add_index(:authors, :name, :unique => true)
  end

  def self.down
    remove_index(:authors, :column => :name)
  end
end
