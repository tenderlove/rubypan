class ReleasesController < ApplicationController
  def latest
    @releases = Release.paginate(
      :page => params[:page],
      :conditions => ['released_on <= ?', Date.today],
      :order => 'released_on desc'
    )
  end
end
