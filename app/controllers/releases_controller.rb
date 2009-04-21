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
      format.html
    end
  end
end
