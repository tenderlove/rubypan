class ReleasesController < ApplicationController
  def latest
    @releases = Release.paginate(
      :page => params[:page],
      :conditions => ['released_on <= ?', Date.today],
      :order => 'released_on desc'
    )

    respond_to do |format|
      format.xml do
        response.content_type = 'application/rss+xml'
      end
      format.atom do
        response.content_type = 'application/atom+xml'
      end
      format.html
    end
  end
  
  def rate
    @session_id = session.session_id #request.session_id.to_s
    release_id = params[:id].to_i
    rating = params[:rating].to_i
    
    if already_rated(release_id, @session_id) == 1
      Rating.transaction do
        old_r = Rating.find(:first, :conditions => ["rateable_id = ? AND session_id = ?", release_id, @session_id])
        old_r.session_id = @session_id
        old_r.rateable_type = params[:rateable_type]
        old_r.rating = rating
        old_r.rateable_id = release_id
        old_r.save
        avg_ratings_and_update(release_id)
      end
    else #not yet rated, insert rating
      Rating.transaction do
        r = Rating.new
        r.session_id = @session_id
        r.rateable_type = params[:rateable_type]
        r.rating = rating
        r.rateable_id = release_id
        r.save
        avg_ratings_and_update(release_id)
      end
    end
    
    
    if (request.xhr?)
      render :text => "You rated this gem a #{rating} out of 5! &nbsp;"
    else
      query = params[:q] || ''
      render :action => 'search', :query => query
    end
  end
  
  private 
    def avg_ratings_and_update release_id
      # average all ratings for that release; count num_ratings, update releases table
      avg = Rating.avg_release_rating(release_id)
      num = Rating.num_ratings(release_id)
      rel = Release.find(release_id)
      rel.avg_rating = avg
      rel.num_ratings = num
      rel.save
    end
    
    def already_rated release_id, session_id
      r = Rating.find(:first, :conditions => ["rateable_id = ? and session_id = ?", release_id, session_id])
      @session_id = session.session_id
      if r == nil #no record
        return 0
      else
        return 1  
      end  
    end
    
end
