require 'test_helper'

class GemTest < ActiveSupport::TestCase
  test "gem has many releases" do
    assert_difference("Release.count") do
      ruby_gems(:nokogiri).releases.create!(
        :name => 'foo-1.0.0',
        :released_on => Date.today,
        :description => 'foobar'
      )
    end
  end
end
