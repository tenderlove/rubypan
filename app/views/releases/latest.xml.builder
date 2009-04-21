xml.rss(:version => '2.0') do
  xml.channel do
    xml.title('rubypan.org - Latest Gems')
    xml.link(url_for( :action => 'index',
                      :controller => 'results',
                      :only_path => false))
    xml.description('Latest released ruby gems')
    xml.language('en-us')
    xml.pubDate(Release.maximum(:created_at))
    @releases.each do |release|
      xml.item do
        xml.title(release.ruby_gem.name)
        xml.author(release.ruby_gem.authors.map { |author|
          author.name || 'nil name'
        }.join(', '))
        xml.link(url_for(
          :action     => 'latest',
          :controller => 'releases',
          :only_path  => false,
          :anchor     => "release_#{release.id}"
        ))
        xml.description(release.summary)
        xml.pubDate(release.created_at)
        xml.guid(url_for(
          :action     => 'latest',
          :controller => 'releases',
          :only_path  => false,
          :anchor     => "release_#{release.id}"
        ))
      end
    end
  end
end
