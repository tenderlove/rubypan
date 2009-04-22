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
    @client_ip = request.remote_ip.to_s
    release_id = params[:id].to_i
    rating = params[:rating].to_i
    
    Rating.transaction do
      r = Rating.new
      r.ip_address = @client_ip
      r.rateable_type = params[:rateable_type]
      r.rating = rating
      r.rateable_id = release_id
      r.save
      avg_ratings_and_update(release_id)
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
    
end
