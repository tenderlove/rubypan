require 'test_helper'

class AuthorTest < ActiveSupport::TestCase
  test "has many gems" do
    assert_difference("RubyGem.count") do
      assert authors(:aaron).ruby_gems.create!(:name => 'foo')
    end
  end
end
