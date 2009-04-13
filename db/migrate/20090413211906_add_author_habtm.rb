class AddAuthorHabtm < ActiveRecord::Migration
  def self.up
    create_table :authors_ruby_gems, :id => false do |t|
      t.references :author
      t.references :ruby_gem
    end
  end

  def self.down
    drop_table :authors_ruby_gems
  end
end
