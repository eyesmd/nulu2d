require "minitest/autorun"
require_relative "../../src/nulu"

class TestSegment < Minitest::Test

  def test_init_default
    s = Nulu::Segment.new()
    assert_equal Nulu::Point.new(0, 0), s.a
    assert_equal Nulu::Point.new(0, 0), s.b
  end

  def test_init_params
    a = Nulu::Point.new(0, 1)
    b = Nulu::Point.new(1, 1)
    s = Nulu::Segment.new(a, b)
    assert_equal a, s.a
    assert_equal b, s.b
  end

  def test_comparisons_parallel
    l1 = Nulu::Segment.make(:center => Nulu::Point.new(1, 0),
                            :direction => Nulu::Point.new(1, 1))
    l2 = Nulu::Segment.make(:center => Nulu::Point.new(2, 1),
                            :direction => Nulu::Point.new(-1, -1))
    assert !l1.perpendicular?(l1)
    assert !l1.perpendicular?(l2)
    assert l1.parallel?(l2)
    assert l2.parallel?(l1)
  end

  def test_comparisons_perpendicular
    l1 = Nulu::Segment.make(:center => Nulu::Point.new(1, 0),
                            :direction => Nulu::Point.new(1, 1))
    l2 = Nulu::Segment.make(:center => Nulu::Point.new(1, 0),
                            :direction => Nulu::Point.new(1, -1))
    assert !l1.parallel?(l2)
    assert !l2.parallel?(l1)
    assert l1.perpendicular?(l2)
    assert l2.perpendicular?(l1)
  end
end
