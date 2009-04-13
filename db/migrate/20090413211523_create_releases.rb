class CreateReleases < ActiveRecord::Migration
  def self.up
    create_table :releases do |t|
      t.string  :name
      t.string  :version
      t.string  :rubyforge_project
      t.date    :released_on
      t.text    :homepage
      t.text    :summary
      t.text    :description
      t.text    :spec
      t.references :ruby_gem

      t.timestamps
    end
  end

  def self.down
    drop_table :releases
  end
end
