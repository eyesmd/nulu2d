require "minitest/autorun"
require_relative "../lib/nulu"


class TestPolygon < Minitest::Test
  def test_init
    p = Nulu::Polygon.new(Nulu::Point.new(-1, 0),
                          Nulu::Point.new(1, 2),
                          Nulu::Point.new(1, 0))
    assert_equal Nulu::Point.new(0, 0), p.anchor
    assert_equal [Nulu::Point.new(-1, 0), Nulu::Point.new(1, 2),
                  Nulu::Point.new(1, 0)],
                 p.vertex
    assert_raises(RuntimeError) { Nulu::Polygon.new(1, 2, 3) }
    assert_raises(RuntimeError) { Nulu::Polygon.new(Nulu::Point.new(-1, 0)) }
  end

  def test_segments
    p = Nulu::Polygon.new(Nulu::Point.new(-1, 0),
                          Nulu::Point.new(1, 2),
                          Nulu::Point.new(1, 0))
    assert_equal [Nulu::Segment.new(Nulu::Point.new(-1, 0),
                                    Nulu::Point.new(1, 2)),
                  Nulu::Segment.new(Nulu::Point.new(1, 2),
                                    Nulu::Point.new(1, 0)),
                  Nulu::Segment.new(Nulu::Point.new(1, 0),
                                    Nulu::Point.new(-1, 0))],
                 p.segments
  end

  def test_size
    p = Nulu::Polygon.new(Nulu::Point.new(-1, -1),
                          Nulu::Point.new(1, 1.3),
                          Nulu::Point.new(1, -1))
    assert_equal 2, p.width
    assert_equal 2.3, p.height
  end

  def test_center
    p = Nulu::Polygon.new(Nulu::Point.new(0, 0),
                          Nulu::Point.new(2, 0),
                          Nulu::Point.new(2, 1),
                          Nulu::Point.new(0, 1))
    assert_equal Nulu::Point.new(1, 0.5), p.center
  end
end
