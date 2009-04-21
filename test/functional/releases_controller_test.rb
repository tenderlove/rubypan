require 'test_helper'

class ReleasesControllerTest < ActionController::TestCase
  def test_latest_gets_latest_releases
    get :latest
    assert assigns(:releases)
    releases = assigns(:releases)
    assert_equal releases.sort_by { |r| r.released_on }.reverse, releases
  end

  def test_latest_as_rss
    get :latest, :format => 'xml'

    assert_equal 'application/rss+xml; charset=utf-8',
      @response.headers['content-type']
    assert assigns(:releases)

    releases = assigns(:releases)

    doc = Nokogiri::XML(@response.body)
    assert_equal releases.length, doc.xpath('//item').length
  end

  def test_latest_as_atom
    get :latest, :format => 'atom'

    assert_equal 'application/atom+xml; charset=utf-8',
      @response.headers['content-type']
    assert assigns(:releases)

    releases = assigns(:releases)

    doc = Nokogiri::XML(@response.body)
    assert_equal releases.length, doc.xpath('//xmlns:entry').length
  end
end
