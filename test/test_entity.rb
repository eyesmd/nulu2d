require "minitest/autorun"
require_relative "../lib/nulu"

class TestEntity < Minitest::Test

  def test_init
    p = Nulu::Polygon.new(Nulu::Point.new(-1, 0),
                          Nulu::Point.new(1, 2),
                          Nulu::Point.new(1, 0))
    e = Nulu::Entity.new(p, 1.0, 0.5, Nulu::Point.new(1, 1))
    assert_equal 1.0, e.mass
    assert_equal p, e.shape # Ehhh... Questionable assert
    assert_equal 0.5, e.friction
    assert_equal Nulu::Point.new(1, 1), e.velocity
  end

  def test_shape_delegation_accesors
    p = Nulu::Polygon.new(Nulu::Point.new(-1, 0),
                          Nulu::Point.new(1, 2),
                          Nulu::Point.new(1, 0))
    e = Nulu::Entity.new(p, 1.0)
    assert_equal 2, e.width
    assert_equal 2, e.height
    assert_equal Nulu::Point.new(0.333333, 0.666666), e.center
    assert_equal (-1), e.left
    assert_equal 1, e.right
    assert_equal 0, e.bottom
    assert_equal 2, e.top
    e.center = Nulu::Point.new(1.5, 1.5); assert_equal Nulu::Point.new(1.5, 1.5), e.center;
    e.left = 1.5; assert_equal 1.5, e.left;
    e.right = 1.5; assert_equal 1.5, e.right;
    e.bottom = 1.5; assert_equal 1.5, e.bottom;
    e.top = 1.5; assert_equal 1.5, e.top;
  end 

  def test_shape_delegation_move
    p = Nulu::Polygon.new(Nulu::Point.new(-1, 0),
                          Nulu::Point.new(1, 2),
                          Nulu::Point.new(1, 0))
    e = Nulu::Entity.new(p, 1.0)
    e.move(Nulu::Point.new(1, 1))
    assert_equal 0, e.left
    assert_equal 1, e.bottom
    e.move_x(-1)
    assert_equal (-1), e.left
    assert_equal 1, e.bottom
    e.move_y(-1)
    assert_equal (-1), e.left
    assert_equal 0, e.bottom
  end

  def test_update
    p = Nulu::Polygon.new(Nulu::Point.new(0, 0),
                          Nulu::Point.new(1, 0),
                          Nulu::Point.new(1, 1),
                          Nulu::Point.new(0, 1))
    e = Nulu::Entity.new(p, 1.0)

    e.update(2.0)
    assert_equal Nulu::Point.new(0.5, 0.5), e.center

    e.velocity = Nulu::Vector.new(1.0, 1.0)
    e.update(2.0)
    assert_equal Nulu::Point.new(2.5, 2.5), e.center
  end
end