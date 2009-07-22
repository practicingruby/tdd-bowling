class Bowler
  ScoreUnknown = Class.new(StandardError)
  InvalidThrow = Class.new(StandardError)

  def initialize
    @score = 0
    @last_ball = nil
  end

  attr_reader :old_balls

  def throw(ball)
    if ball > 10 || @last_ball.to_i + ball > 10
      raise(InvalidThrow)
    end
    if @last_ball && @last_ball + ball == 10
      @state = :spare
    elsif ball == 10
      if @last_ball == 0
        @state = :spare
      else
        @state = :strike
      end
    end
    @score += ball
    @last_ball = ball
  end

  def score
    if @score == 10
      @state = :spare
      raise(ScoreUnknown)
    else
      @score
    end
  end
  
  def state
    @state
  end

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

  def test_must_not_provide_a_score_when_score_is_pending
    @bowler.throw(5)
    @bowler.throw(5)
    assert_raises(Bowler::ScoreUnknown) do
      @bowler.score
    end
    
    assert_equal :spare, @bowler.state
  end
  
  def test_must_recognize_strike
    @bowler.throw(10)
    assert_equal :strike, @bowler.state
  end

  def test_must_recognize_second_ball_ten_is_a_spare
    @bowler.throw(0)
    @bowler.throw(10)
    assert_equal :spare, @bowler.state
  end
  
  def test_must_recognize_first_plus_second_ball_ten_is_a_spare
    @bowler.throw(3)
    @bowler.throw(7)
    assert_equal :spare, @bowler.state
  end

  def test_must_not_knock_down_more_than_10_pins
    assert_raises(Bowler::InvalidThrow) do
      @bowler.throw(16)
    end
  end
  
  def test_must_not_knock_down_more_than_10_in_1_frame
    assert_raises(Bowler::InvalidThrow) do
      @bowler.throw(5)
      @bowler.throw(8)
    end
  end

  def test_must_keep_track_of_last_two_balls_throw 
    assert_equal [], @bowler.old_balls

    @bowler.throw(7)
    assert_equal [7], @bowler.old_balls
    
    @bowler.throw(3)
    assert_equal [7,3], @bowler.old_balls

    @bowler.throw(9)
    assert_equal [3,9], @bowler.old_balls
  end

end
