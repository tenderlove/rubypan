require 'test_helper'

class RatingTest < ActiveSupport::TestCase
  fixtures :releases, :authors, :ruby_gems, :ratings

  def test_from_session_id
    from = Rating.by(ratings(:one).session_id)
    manual = Rating.find_all_by_session_id(ratings(:one).session_id)
    assert_equal manual, from
  end
end
