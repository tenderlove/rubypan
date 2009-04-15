task :import_gems => [:environment] do
  unless ENV['MARSHAL_SPEC']
    require 'tempfile'
    Dir.chdir(Dir::tmpdir) do
      url = 'http://gems.rubyforge.org/Marshal.4.8'
      system("wget #{url} || curl -O #{url}")
    end
    ENV['MARSHAL_SPEC'] = File.join(Dir::tmpdir, 'Marshal.4.8')
  end

  spec = Marshal.load(File.read(ENV['MARSHAL_SPEC']))

  gem_cache = Hash.new { |h,name|
    h[name] = RubyGem.create!(:name => name)
  }
  author_cache = {}

  spec.gems.each do |name, gemspec|
    authors = []
    [gemspec.email].flatten.zip([gemspec.author].flatten).each do |email,author|
      authors << (author_cache[[author, email]] ||= Author.create!(
        :name   => author,
        :email  => email
      ))
    end

    rubygem = gem_cache[gemspec.name]

    authors.each do |author|
      unless author.ruby_gems.find_by_id(rubygem.id)
        author.ruby_gems << rubygem
      end
    end

    next if rubygem.releases.find_by_version(gemspec.version)
    begin
      rubygem.releases.create!(
        :name         => name,
        :meta         =>
          ([gemspec.email].flatten + [gemspec.author].flatten).join(', '),
        :version      => gemspec.version.to_s,
        :homepage     => gemspec.homepage,
        :rubyforge_project => gemspec.rubyforge_project,
        :released_on  => gemspec.date,
        :summary      => gemspec.summary,
        :description  => gemspec.description,
        :spec         => gemspec.to_yaml
      )
    rescue Gem::Exception, ArgumentError => e
      puts "wtf: #{name} => #{e}"
    end
  end

  seen = {}
  Release.find(:all, :order => 'released_on desc').each do |release|
    next if seen[release.ruby_gem_id]
    release.latest = true
    release.save!
    seen[release.ruby_gem_id] = true
  end
end
