require 'test_helper'

class ReleasesControllerTest < ActionController::TestCase
  def test_latest_gets_latest_releases
    get :latest
    assert assigns(:releases)
    releases = assigns(:releases)
    assert_equal releases.sort_by { |r| r.released_on }.reverse, releases
  end
end
