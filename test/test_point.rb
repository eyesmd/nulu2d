require "minitest/autorun"
require_relative "../lib/nulu"

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
  end

  def test_polar_write
    p = Nulu::Point.new()
    p.norm = 1
    p.angle = Math::PI/4
    assert_in_delta p.x, 0.707
    assert_in_delta p.y, 0.707
  end

  def test_point_to
    p = Nulu::Point.new()
    p.point_to(3, 4)
    assert_equal p.x, 3
    assert_equal p.y, 4
  end

  def test_apply
    p = Nulu::Point.new(3, 4)
    p.apply(Nulu::Point.new(2, 1))
    assert_equal p.x, 5
    assert_equal p.y, 5
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

  def test_zero_fail
    p = Nulu::Point.new(0, -1)
    assert !p.zero?
  end

  def test_zero_sucess
    p = Nulu::Point.new(0, 0)
    assert p.zero?
  end

  def test_unit
    p = Nulu::Point.new(0, -1)
    assert_in_delta 1, p.unit.norm
    assert_in_delta p.angle, p.unit.angle
  end

  def test_trim
    p = Nulu::Point.new(0, -1)
    p.trim(0.2)
    assert_in_delta 0.2, p.norm
    assert_in_delta 2.0*Math::PI*3.0/4.0, p.angle
  end

  def test_distance
    v1 = Nulu::Point.new(2, 1)
    v2 = Nulu::Point.new(5, 5)
    assert Math::sqrt(3**2+4**2), v1.distance(v2)
  end
end
