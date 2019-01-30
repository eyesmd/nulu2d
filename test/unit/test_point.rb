require "minitest/autorun"
require_relative "../../src/nulu"

class TestPoint < Minitest::Test
  def test_init
    p = Nulu::Point.new(2, 5)
    assert_equal 2, p.x
    assert_equal 5, p.y
  end

  def test_make_simple
    p = Nulu::Point.make(:angle => -Math::PI, :norm => 1)
    assert_in_delta (-1), p.x 
    assert_in_delta 0, p.y
  end

  def test_make_complex
    p = Nulu::Point.make(:angle => -Math::PI*1/4, :norm => Math::sqrt(8))
    assert_in_delta 2, p.x
    assert_in_delta (-2), p.y
  end

  def test_polar_read
    p = Nulu::Point.new(-1, -1)
    assert_in_delta (Math::PI*5.0/4.0), p.angle
    assert_in_delta Math::sqrt(2), p.norm

    p = Nulu::Point.new(1, 0.001)
    assert_in_delta 0, p.angle

    p = Nulu::Point.new(1, -0.001)
    assert_in_delta (2.0*Math::PI), p.angle
  end

  def test_polar_write
    p = Nulu::Point.new()
    p.norm = 1
    p.angle = Math::PI/4
    assert_in_delta p.x, 0.707
    assert_in_delta p.y, 0.707

    p.angle = 0
    assert_in_delta p.x, 1.0
    assert_in_delta p.y, 0.0

    p.angle = (2.0*Math::PI - 0.1)
    assert_in_delta p.x, 0.995
    assert_in_delta p.y, -0.099

    p.angle = (2.0*Math::PI)
    assert_in_delta p.x, 1.0
    assert_in_delta p.y, 0.0

    p.angle = (4.0*Math::PI)
    assert_in_delta p.x, 1.0
    assert_in_delta p.y, 0.0
  end

  def test_point_to
    p = Nulu::Point.new()
    p.point_to(3, 4)
    assert_equal p.x, 3
    assert_equal p.y, 4
  end

  def test_operators_sum
    v1 = Nulu::Point.new(2, 2)
    v2 = Nulu::Point.new(1, -3)
    assert_equal Nulu::Point.new(3, -1), v1 + v2
  end

  def test_operators_difference
    v1 = Nulu::Point.new(2, 2)
    v2 = Nulu::Point.new(1, -3)
    assert_equal Nulu::Point.new(1, 5), v1 - v2
  end

  def test_operators_dot_product
    v1 = Nulu::Point.new(2, 2)
    v2 = Nulu::Point.new(1, -3)
    assert_equal (-4), v1 * v2
  end

  def test_operators_num_product
    v2 = Nulu::Point.new(1, -3)
    assert_equal Nulu::Point.new(-0.5, 1.5), v2 * -0.5
    assert_raises(RuntimeError) { v2 * 'a' }
  end

  def test_operators_num_division
    v1 = Nulu::Point.new(2, 2)
    assert_equal Nulu::Point.new(1, 1), v1 / 2
  end

  def test_operators_vector_product
    v1 = Nulu::Point.new(2, 2)
    v2 = Nulu::Point.new(1, -3)
    assert_equal (-8), v1 ** v2
  end

  def test_projection_regular
    p1 = Nulu::Point.new(1, 1).unit()
    p2 = Nulu::Point.new(1, 0)
    assert_in_delta Math.cos(Math::PI/4), p1.sproject_to(p2)
    assert_in_delta Math.cos(Math::PI/4), p2.sproject_to(p1)
    assert Nulu::Point.new(Math.cos(Math::PI/4), 0), p1.vproject_to(p2)
  end

  def test_projection_parallel
    p1 = Nulu::Point.new(1, 1).unit()
    p2 = Nulu::Point.new(1, 1).unit() / 2
    assert_in_delta 1, p1.sproject_to(p2)
    assert_in_delta 0.5, p2.sproject_to(p1)
    assert p1, p1.vproject_to(p2)
    assert p2, p2.vproject_to(p1)
  end

  def test_inverts
    p = Nulu::Point.new(1, 1).invert()
    assert_equal (-1), p.x
    assert_equal (-1), p.y
    p = Nulu::Point.new(1, 1).invert_x()
    assert_equal (-1), p.x
    assert_equal 1, p.y
    p = Nulu::Point.new(1, 1).invert_y()
    assert_equal 1, p.x
    assert_equal (-1), p.y
  end

  def test_zero
    assert !Nulu::Point.new(0, -1).zero?
    assert Nulu::Point.new(0, 0).zero?
  end

  def test_unit
    p = Nulu::Point.new(0, -1)
    assert_in_delta 1, p.unit.norm
    assert_in_delta p.angle, p.unit.angle
  end

  def test_trim
    p = Nulu::Point.new(0, -1).trim(0.2)
    assert_in_delta 0.2, p.norm
    assert_in_delta 2.0*Math::PI*3.0/4.0, p.angle
  end

  def test_distance
    v1 = Nulu::Point.new(2, 1)
    v2 = Nulu::Point.new(5, 5)
    assert Math::sqrt(3**2+4**2), v1.distance(v2)
  end

  def test_parallel
    v1 = Nulu::Point.new(1, 1)
    v2 = Nulu::Point.new(-1, -1)
    assert !v1.perpendicular?(v1)
    assert !v1.perpendicular?(v2)
    assert v1.parallel?(v2)
    assert v2.parallel?(v1)
  end

  def test_comparisons_perpendicular
    v1 = Nulu::Point.new(1, 1)
    v2 = Nulu::Point.new(1, -1)
    assert !v1.parallel?(v2)
    assert !v2.parallel?(v1)
    assert v1.perpendicular?(v2)
    assert v2.perpendicular?(v1)
  end

  def test_decomposition
    # regular
    parallel, perpendicular = Nulu::Point.new(1, 0).decompose_into(Nulu::Point.new(1, 0))
    assert_equal Nulu::Point.new(1, 0), parallel
    assert_equal Nulu::Point.new(0, 0), perpendicular

    # opposite
    parallel, perpendicular = Nulu::Point.new(1, 0).decompose_into(Nulu::Point.new(-1, 0))
    assert_equal Nulu::Point.new(1, 0), parallel
    assert_equal Nulu::Point.new(0, 0), perpendicular

    # vertical
    parallel, perpendicular = Nulu::Point.new(1, 0).decompose_into(Nulu::Point.new(0, 1))
    assert_equal Nulu::Point.new(0, 0), parallel
    assert_equal Nulu::Point.new(1, 0), perpendicular

    # both directions
    parallel, perpendicular = Nulu::Point.new(1, 1).decompose_into(Nulu::Point.new(0, 1))
    assert_equal Nulu::Point.new(0, 1), parallel
    assert_equal Nulu::Point.new(1, 0), perpendicular

    # diagonal parallel
    parallel, perpendicular = Nulu::Point.new(1, 0).decompose_into(Nulu::Point.new(1, 1))
    assert_equal Nulu::Point.new(0.5, 0.5), parallel
    assert_equal Nulu::Point.new(0.5, -0.5), perpendicular
  end
end
