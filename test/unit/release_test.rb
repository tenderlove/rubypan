require 'test_helper'

class ReleaseTest < ActiveSupport::TestCase
  fixtures :releases, :authors, :ruby_gems

  test "belongs to ruby gem" do
    assert releases(:nokogiri_1_0_0).ruby_gem
  end

  test "import will import things" do
    m = File.join(File.dirname(__FILE__), '..', 'assets', 'Marshal.4.8')
    spec = Marshal.load(File.read(m))

    assert_difference('Release.count', spec.gems.keys.length) do
      Release.import(m)
    end
  end

  def test_import_is_idempotent
    m = File.join(File.dirname(__FILE__), '..', 'assets', 'Marshal.4.8')
    spec = Marshal.load(File.read(m))

    assert_difference('Release.count', spec.gems.keys.length) do
      Release.import(m)
    end

    assert_no_difference('Release.count') do
      assert_no_difference('RubyGem.count') do
        assert_no_difference('Author.count') do
          Release.import(m)
        end
      end
    end
  end

  def test_import_makes_newest_releases_newest
    m = File.join(File.dirname(__FILE__), '..', 'assets', 'Marshal.4.8')
    spec = Marshal.load(File.read(m))

    Release.find(:all).each { |r|
      r.latest = false
      r.save!
    }

    assert_difference('Release.count', spec.gems.keys.length) do
      Release.import(m)
    end

    RubyGem.find(:all, :include => :releases).each do |rubygem|
      rubygem.releases.sort_by { |x|
        x.released_on
      }.reverse.each_with_index do |release, i|
        assert_equal(i == 0 ? true : false, release.latest)
      end
    end
  end
end
