class AddRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.integer :rating
      t.integer :rateable_id, :null => false
      t.string :rateable_type, :null => false
      t.string :ip_address
    end
    
    add_index :ratings, [:rateable_id, :rating]    # Not required, but should help more than it hurts
  end

  def self.down
    drop_table :ratings
  end
  
end
