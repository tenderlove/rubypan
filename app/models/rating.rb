class Rating < ActiveRecord::Base
  
  def self.avg_release_rating release_id
    # avg all ratings for that release ID
    Rating.average(:rating, :conditions => ['rateable_id = ?', release_id])
  end
  
end
