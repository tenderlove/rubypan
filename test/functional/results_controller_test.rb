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
  
  test "ratings widget shows up with links" do
    get :search, :format => 'Marshal', :q => 'nokogiri'
    #assert assigns(:releases)
    #number of nokogiri gems = 2
    num_nokogiri_gems = Releases.find(:all, :conditions => ['ruby_gem = ?', 'nokogiri'])
    assert_select 'div#rate_area', :count => 1
    assert_select 'ul.gem-rating', :count => num_nokogiri_gems
    assert_select 'a.one-gems', :count => num_nokogiri_gems
  end
  
  test "clicking on rating executes xhr request" do
  end
  
end
