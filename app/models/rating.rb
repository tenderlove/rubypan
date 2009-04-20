class Rating < ActiveRecord::Base
  
  def self.avg_release_rating release_id
    Rating.average(:rating, :conditions => ['rateable_id = ?', release_id])
  end
  
  def self.num_ratings release_id
    Rating.count(:rating, :conditions => ['rateable_id = ?', release_id])
  end
  
end
