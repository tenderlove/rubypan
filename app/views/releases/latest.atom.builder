xml.feed(:xmlns => 'http://www.w3.org/2005/Atom') do
  xml.title('rubypan.org - Latest Gems')
  xml.link(:href => url_for( :action => 'index',
                    :controller => 'results',
                    :only_path => false))
  xml.updated(Release.maximum(:created_at))
  xml.id(url_for( :action => 'index',
                    :controller => 'results',
                    :only_path => false))
  @releases.each do |release|
    xml.entry do
      xml.title(release.ruby_gem.name)
      xml.link(:href => url_for(
        :action     => 'latest',
        :controller => 'releases',
        :only_path  => false,
        :anchor     => "release_#{release.id}"
      ))
      xml.id(url_for(
        :action     => 'latest',
        :controller => 'releases',
        :only_path  => false,
        :anchor     => "release_#{release.id}"
      ))
      xml.updated(release.created_at)
      xml.summary(release.summary)
    end
  end
end
