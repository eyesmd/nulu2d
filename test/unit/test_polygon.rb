require "minitest/autorun"
require_relative "../../src/nulu"


class TestPolygon < Minitest::Test
  def test_equals_polygons
    p1 = Nulu::Polygon.new(Nulu::Point.new(-1, 0),
                          Nulu::Point.new(1, 2),
                          Nulu::Point.new(1, 0))
    p2 = Nulu::Polygon.new(Nulu::Point.new(1, 2),
                          Nulu::Point.new(1, 0),
                          Nulu::Point.new(-1, 0))
    p3 = Nulu::Polygon.new(Nulu::Point.new(1, 0),
                          Nulu::Point.new(-1, 0),
                          Nulu::Point.new(1, 2))
    pr1 = Nulu::Polygon.new(Nulu::Point.new(1, 0),
                          Nulu::Point.new(1, 2),
                          Nulu::Point.new(-1, 0))
    pr2 = Nulu::Polygon.new(Nulu::Point.new(-1, 0),
                          Nulu::Point.new(1, 0),
                          Nulu::Point.new(1, 2))
    pr3 = Nulu::Polygon.new(Nulu::Point.new(1, 2),
                          Nulu::Point.new(-1, 0),
                          Nulu::Point.new(1, 0))
    assert_equal p1, p2
    assert_equal p2, p3
    assert_equal p3, p1

    assert_equal pr1, pr2
    assert_equal pr2, pr3
    assert_equal pr3, pr1

    assert_equal p1, pr1
    assert_equal p2, pr2
    assert_equal p3, pr3
  end

  def test_unequal_polygons
    p = Nulu::Rectangle.new(1, 1)
    q = Nulu::Rectangle.new(2, 1)
    r = Nulu::Rectangle.new(1, 1, Nulu::Point.new(10, 10))

    assert p != q
    assert p != r
    assert q != r
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

  def test_centroid_simple
    p = Nulu::Polygon.new(
      Nulu::Point.new(0, 0),
      Nulu::Point.new(1, 0),
      Nulu::Point.new(0, 1))
    assert_equal p.centroid, (p.vertex.reduce(&:+) / 3.0)
  end

  def test_centroid_complex
    p = Nulu::Polygon.new(
      Nulu::Point.new(45.3142533036254, -93.47527313511819),
      Nulu::Point.new(45.31232182518015, -93.34893036168069),
      Nulu::Point.new(45.23694281999268, -93.35167694371194),
      Nulu::Point.new(45.23500870841669, -93.47801971714944),
      Nulu::Point.new(45.3142533036254, -93.47527313511819))
    assert_equal p.centroid, Nulu::Point.new(45.27463866133501, -93.41400121829719)
  end

  def test_rotate_around
    p = Nulu::Polygon.new(
      Nulu::Point.new(0, 0),
      Nulu::Point.new(1, 0),
      Nulu::Point.new(0, 1))
    p.rotate_around(Math::PI*0.5, Nulu::Point.new(0, 1))
    
    assert_equal Nulu::Polygon.new( Nulu::Point.new(0, 1), Nulu::Point.new(1, 1), Nulu::Point.new(1, 2) ), p
  end

  def test_rotate_around_centroid
    p = Nulu::Polygon.new(
      Nulu::Point.new(0, 0),
      Nulu::Point.new(1, 0),
      Nulu::Point.new(1, 1),
      Nulu::Point.new(0, 1))
    p.rotate(Math::PI*0.25)

    ep = Nulu::Polygon.new(
      Nulu::Point.new(0, Math::sqrt(0.5)),
      Nulu::Point.new(Math::sqrt(0.5), 0),
      Nulu::Point.new(0, -Math::sqrt(0.5)),
      Nulu::Point.new(-Math::sqrt(0.5), 0))
    ep.move(Nulu::Point.new(0.5, 0.5))
    
    assert_equal ep, p
  end
end
