require 'test_helper'

class AuthorTest < ActiveSupport::TestCase
  test "has many gems" do
    assert_difference("RubyGem.count") do
      assert authors(:aaron).ruby_gems.create!(:name => 'foo')
    end
  end

  def test_author_has_many_releases_throug_gem
    author = authors(:aaron)
    assert author.ruby_gems.length > 0
    assert_equal author.ruby_gems.map { |rg|
      rg.releases
    }.flatten.sort_by { |r| r.id }, author.releases.sort_by { |ar| ar.id }
  end
end
