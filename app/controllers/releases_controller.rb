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
    release = Release.find(params[:id])
    ratings = release.ratings.by(session.session_id)

    Rating.transaction do
      if ratings.length > 0
        rating = ratings.first
        rating.rating = rating
        rating.save!
      else #not yet rated, insert rating
        release.ratings.create!(
          :session_id     => session.session_id,
          :rateable_type  => params[:rateable_type],
          :rating         => params[:rating]
        )
      end

      release.avg_rating  = Rating.avg_release_rating(release.id)
      release.num_ratings = Rating.num_ratings(release.id)
      release.save!
    end


    if (request.xhr?)
      render :text => "You rated this gem a #{params[:rating]} out of 5! &nbsp;"
    else
      query = params[:q] || ''
      render :action => 'search', :query => query
    end
  end
end
