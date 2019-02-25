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

  def test_accesors
    s = Nulu::Segment.new(Nulu::Point.new(0, 1), Nulu::Point.new(1, 1))

    assert_equal Nulu::Point.new(0, 1), s.center
    assert_equal Nulu::Point.new(1, 0), s.direction
  end

  def test_make
    s = Nulu::Segment.make(:center => Nulu::Point.new(1, 0),
                           :direction => Nulu::Point.new(1, 1))

    assert_equal Nulu::Point.new(1, 0), s.a
    assert_equal Nulu::Point.new(2, 1), s.b
  end

  def test_distance_point_to_segment
    s = Nulu::Segment.new(Nulu::Point.new(0, 0), Nulu::Point.new(1, 1))

    p = Nulu::Point.new(0, 1)
    assert_in_delta Math::sqrt(2)/2, p.distance(s)
    assert_equal s.distance(p), p.distance(s)

    p = Nulu::Point.new(1, 0)
    assert_in_delta Math::sqrt(2)/2, p.distance(s)
    assert_equal s.distance(p), p.distance(s)

    p = Nulu::Point.new(0, 0.5)
    assert_in_delta Math::sqrt(2)/4, p.distance(s)
    assert_equal s.distance(p), p.distance(s)

    p = Nulu::Point.new(0, -1)
    assert_in_delta 1, p.distance(s)
    assert_equal s.distance(p), p.distance(s)

    p = Nulu::Point.new(0, 3)
    assert_in_delta Math::sqrt(5), p.distance(s)
    assert_equal s.distance(p), p.distance(s)
  end

  def test_distance_segment_to_segment
    a = Nulu::Segment.new(Nulu::Point.new(0, 0), Nulu::Point.new(2, 0))

    b = Nulu::Segment.new(Nulu::Point.new(0, 3), Nulu::Point.new(3, 0))
    assert_in_delta Math::sqrt(0.5**2+0.5**2), a.distance(b)

    b = Nulu::Segment.new(Nulu::Point.new(0, 3), Nulu::Point.new(2, 1))
    assert_in_delta 1, a.distance(b)

    b = Nulu::Segment.new(Nulu::Point.new(2, 1), Nulu::Point.new(3, 0))
    assert_in_delta Math::sqrt(0.5**2+0.5**2), a.distance(b)

    b = Nulu::Segment.new(Nulu::Point.new(3, 0), Nulu::Point.new(3, 3))
    assert_in_delta 1, a.distance(b)

    b = Nulu::Segment.new(Nulu::Point.new(-2, 2), Nulu::Point.new(4, 2))
    assert_in_delta 2, a.distance(b)
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
