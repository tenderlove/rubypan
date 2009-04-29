class Release < ActiveRecord::Base
  belongs_to :ruby_gem
  has_many :ratings, :foreign_key => 'rateable_id'

  index do
    name        'A'
    summary     'B'
    meta        'C'
    description 'C'
  end

  named_scope :latest, lambda {
    { :conditions => ['latest = true'] }
  }

  def self.import filename
    spec = Marshal.load(File.read(filename))

    gem_cache = Hash.new { |h,name|
      h[name] = RubyGem.find_or_create_by_name(name)
    }

    author_cache = Hash.new { |h, tuple|
      a = Author.find_or_create_by_name(tuple.first)
      if tuple.last && a.email != tuple.last
        a.email = tuple.last
        a.save!
      end
      h[tuple] = a
    }

    release_names = {}
    Release.find(:all, :select => 'name').each { |r|
      release_names[r.name] = true
    }

    spec.gems.each do |name, gemspec|
      next if release_names[name]

      Release.transaction do
        rubygem = gem_cache[gemspec.name]

        authors = []
        Array(gemspec.email).zip(Array(gemspec.author)).each do |email,author|
          authors << author_cache[[author, email]]
        end

        authors.each do |author|
          unless author.ruby_gems.include?(rubygem)
            author.ruby_gems << rubygem
          end
        end

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
    end

    Release.transaction do
      Release.connection.execute('update releases set latest = false')
      seen = {}
      latest_ids = []
      Release.find(:all, :order => 'released_on desc').each do |release|
        next if seen[release.ruby_gem_id]
        latest_ids << release.id
        seen[release.ruby_gem_id] = true
      end
      Release.update_all('latest = true', "id IN (#{latest_ids.join(',')})")
    end
  end
end
