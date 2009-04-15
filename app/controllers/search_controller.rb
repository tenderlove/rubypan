class SearchController < ApplicationController
  def index
    redirect_to(:action => 'search', :q => params[:q]) if params[:q]
  end

  def search
    @releases = Release.search(params[:q]).latest.find(:all,
      :include => [:ruby_gem => :authors]
    )
  end
end
