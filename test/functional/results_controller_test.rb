require 'test_helper'

class ResultsControllerTest < ActionController::TestCase
  test "search provides releases" do
    get :search
    assert assigns(:releases)
  end

  test "index redirects to search when there is a q" do
    get :index, :q => 'foobar'
    assert_redirected_to :action => 'search'
  end
end
