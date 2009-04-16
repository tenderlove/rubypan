class ResultsController < ApplicationController
  def index
    redirect_to(:action => 'search', :q => params[:q]) if params[:q]
  end

  def search
    @releases = Release.search(params[:q].sub('.', '')).latest.find(:all,
      :include => [:ruby_gem => :authors]
    )

    if params[:f] == 'Marshal' then
      response.charset = nil
      response.content_type = 'application/octet-stream'
      response.header['Content-Transfer-Encoding'] = 'binary'

      source = 'http://gems.rubyforge.org/'
      releases = @releases.map do |release|
        [[release.ruby_gem.name, Gem::Version.new(release.version),
          Gem::Platform::RUBY], source]
      end

      render :text => Marshal.dump(releases)
    end
  end
end
