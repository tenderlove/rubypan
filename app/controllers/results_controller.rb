class ResultsController < ApplicationController
  def index
    redirect_to(:action => 'search', :q => params[:q]) if params[:q]
  end

  def search
    query = params[:q] || ''

    @releases = Release.search(params[:q].gsub('.', ' ')).latest.find(:all,
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
  
end
