class Bowler

  def throw(ball)
    @score = ball
  end
  

  attr_reader :score


end

require "test/unit"

class BowlerTest < Test::Unit::TestCase

  def setup
    @bowler = Bowler.new
  end

  def test_must_record_a_throw
    @bowler.throw(3)
    assert_equal 3, @bowler.score
  end
  
  def test_must_add_throws
    @bowler.throw(3)
    @bowler.throw(4)
    assert_equal 7, @bowler.score
  end

end
