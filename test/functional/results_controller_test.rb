require 'test_helper'

class ResultsControllerTest < ActionController::TestCase
  
  fixtures :releases, :ruby_gems, :authors

  test "search provides releases" do
    get :search, :q => 'foobar'
    assert assigns(:releases)
  end
  
  test "search returns Marshal" do
    get :search, :format => 'Marshal', :q => 'nokogiri'
    assert assigns(:releases)
    assert_equal 'application/octet-stream', @response.headers['content-type']
  
    expected = [
      [['nokogiri', Gem::Version.new('1.0.1'), Gem::Platform::RUBY],
       'http://gems.rubyforge.org/']
    ]
  
    assert_equal expected, Marshal.load(@response.body)
  end
  
  test "index redirects to search when there is a q" do
    get :index, :q => 'foobar'
    assert_redirected_to :action => 'search'
  end
  
  test "ratings partial shows up with links" do
    q = releases(:nokogiri_1_0_0).ruby_gem.name
    assert_equal q, 'nokogiri'
    get :search, :format => 'html', :q => q
    assert_response :success
    
    #6 total
    assert_select 'li.current-rating', 1
    assert_select 'ul.gem-rating' do
      assert_select 'li', 6
    end
    #5 rateables
    assert_select 'ul.gem-rating' do
      assert_select 'li' do
        assert_select 'a.rateable', 5
      end
    end
    
    assert_select 'div#rate_area', :count => 1
    assert_select 'ul.gem-rating', :count => 1
    assert_select 'a.one-gems', :count => 1
    assert_select 'a.two-gems', :count => 1
    assert_select 'a.three-gems', :count => 1
    assert_select 'a.four-gems', :count => 1
    assert_select 'a.five-gems', :count => 1
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




