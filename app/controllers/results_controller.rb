class ResultsController < ApplicationController
  def index
    redirect_to(:action => 'search', :q => params[:q]) if params[:q]
  end

  def search
    query = params[:q] || ''

    @releases = Release.search(params[:q].sub('.', '')).latest.find(:all,
      :include => [:ruby_gem => :authors]
    )

    respond_to do |format|
      format.Marshal do
        response.header['Content-Transfer-Encoding'] = 'binary'

        source = 'http://gems.rubyforge.org/'
        releases = @releases.map do |release|
          [[release.ruby_gem.name, Gem::Version.new(release.version),
            Gem::Platform::RUBY], source]
        end

        return render(:text => Marshal.dump(releases))
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
      render :text => "You rated this gem a #{rating} out of 5"
    else
      query = params[:q] || ''
      render :action => 'search', :query => query
    end
  end
  
  private 
    def avg_ratings_and_update release_id
      # average all ratings for that release; update releases table
      avg = Rating.avg_release_rating(release_id)
      rel = Release.find(release_id)
      rel.avg_rating = avg
      rel.save
    end
    
end
