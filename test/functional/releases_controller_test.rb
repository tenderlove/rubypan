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
  
  test "ratings partial shows up with links" do
    q = releases(:nokogiri_1_0_0).ruby_gem.name
    assert_equal q, 'nokogiri'
    
    num_releases = Release.count(:all)
    first_release_id = Release.find(:first).id
    
    get :latest, :format => 'html', :q => q
    assert_response :success
    
    #6 total
    assert_select 'li.current-rating', 1 * num_releases
    assert_select 'ul.gem-rating' do
      assert_select 'li', 6 * num_releases
    end
    #5 rateables
    assert_select 'ul.gem-rating' do
      assert_select 'li' do
        assert_select 'a.rateable', 5 * num_releases
      end
    end
    
    search_text = ""
    assert_select "div#rate_area_#{first_release_id}", :count => 1 
    assert_select 'ul.gem-rating', :count => 1 * num_releases
    assert_select 'a.one-gems', :count => 1 * num_releases
    assert_select 'a.two-gems', :count => 1 * num_releases
    assert_select 'a.three-gems', :count => 1 * num_releases
    assert_select 'a.four-gems', :count => 1 * num_releases
    assert_select 'a.five-gems', :count => 1 * num_releases
  end
  
  test "a new rating posted via xhr should add a record to the ratings table, and save the average" do
    rel_id = releases(:nokogiri_1_0_0).id
    num_ratings = Rating.num_ratings(rel_id)
    puts num_ratings
    
    #rate once
    xhr :post, :rate, {:id => rel_id, :rateable_type => 'Release', :rating => 3}
    assert_response :success
    num_ratings_after = Rating.num_ratings(rel_id)
    assert_equal num_ratings_after, num_ratings + 1
    r = Release.find(rel_id)
    assert_equal 3, r.avg_rating
    assert_equal 1, r.num_ratings
    
    #rate twice
    xhr :post, :rate, {:id => rel_id, :rateable_type => 'Release', :rating => 5}
    assert_response :success
    third_rating = Rating.num_ratings(rel_id)
    assert_equal third_rating, num_ratings_after + 1
    r = Release.find(rel_id)
    assert_equal 4, r.avg_rating
    assert_equal 2, r.num_ratings
  end
end
