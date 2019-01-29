require "minitest/autorun"
require_relative "../../src/nulu"


class TestPolygon < Minitest::Test
  def test_init
    p = Nulu::Polygon.new(Nulu::Point.new(-1, 0),
                          Nulu::Point.new(1, 2),
                          Nulu::Point.new(1, 0))
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

  def test_positions
    p = Nulu::Polygon.new(Nulu::Point.new(0, -2),
                          Nulu::Point.new(2, -2),
                          Nulu::Point.new(2, 1),
                          Nulu::Point.new(0, 1))
    assert_equal Nulu::Point.new(1, -0.5), p.center
    assert_equal 0, p.left
    assert_equal 2, p.right
    assert_equal (-2), p.bottom
    assert_equal 1, p.top
  end

  def test_change_left
    p = Nulu::Polygon.new(Nulu::Point.new(0, -2),
                          Nulu::Point.new(2, -2),
                          Nulu::Point.new(2, 1),
                          Nulu::Point.new(0, 1))
    p.left = -2
    assert_equal Nulu::Point.new(-1, -0.5), p.center
  end

  def test_change_right
    p = Nulu::Polygon.new(Nulu::Point.new(0, -2),
                          Nulu::Point.new(2, -2),
                          Nulu::Point.new(2, 1),
                          Nulu::Point.new(0, 1))
    p.right -= 1
    assert_equal Nulu::Point.new(0, -0.5), p.center
  end

  def test_change_bottom
    p = Nulu::Polygon.new(Nulu::Point.new(0, -2),
                          Nulu::Point.new(2, -2),
                          Nulu::Point.new(2, 1),
                          Nulu::Point.new(0, 1))
    p.bottom = 1
    assert_equal Nulu::Point.new(1, 2.5), p.center
  end

  def test_change_top
    p = Nulu::Polygon.new(Nulu::Point.new(0, -2),
                          Nulu::Point.new(2, -2),
                          Nulu::Point.new(2, 1),
                          Nulu::Point.new(0, 1))
    p.top = 1
    assert_equal Nulu::Point.new(1, -0.5), p.center
  end

  def test_change_center
    p = Nulu::Polygon.new(Nulu::Point.new(0, -2),
                          Nulu::Point.new(2, -2),
                          Nulu::Point.new(2, 1),
                          Nulu::Point.new(0, 1))
    p.center = Nulu::Point.new(0, 0)
    assert_equal (-1), p.left
    assert_equal 1, p.right
    assert_equal (-1.5), p.bottom
    assert_equal 1.5, p.top
  end

  def test_move
    p = Nulu::Polygon.new(Nulu::Point.new(0, 0),
                          Nulu::Point.new(2, 0),
                          Nulu::Point.new(2, 1),
                          Nulu::Point.new(0, 1))

    p.move(Nulu::Point.new(1, -1))
    assert_equal Nulu::Point.new(1, -1), p.vertex.first
    assert_equal Nulu::Point.new(1, 0), p.vertex.last
  end

  def test_move_x
  p = Nulu::Polygon.new(Nulu::Point.new(0, 0),
                          Nulu::Point.new(2, 0),
                          Nulu::Point.new(2, 1),
                          Nulu::Point.new(0, 1))

    p.move_x(3)
    assert_equal Nulu::Point.new(3, 0), p.vertex.first
    assert_equal Nulu::Point.new(3, 1), p.vertex.last
  end

  def test_move_y
    p = Nulu::Polygon.new(Nulu::Point.new(0, 0),
                          Nulu::Point.new(2, 0),
                          Nulu::Point.new(2, 1),
                          Nulu::Point.new(0, 1))

    p.move_y(-1)
    assert_equal Nulu::Point.new(0, -1), p.vertex.first
    assert_equal Nulu::Point.new(0, 0), p.vertex.last
  end
end
