require 'test_helper'

class AuthorsControllerTest < ActionController::TestCase
  def test_index_finds_authors
    get :index
    assert assigns(:authors)
  end

  def test_show_gets_author
    get :show, :id => authors(:aaron).id
    assert assigns(:author)
    assert_equal authors(:aaron), assigns(:author)
  end
end
