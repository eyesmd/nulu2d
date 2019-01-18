require "minitest/autorun"
require_relative "../src/nulu"
require 'pry'

class TestPhysics < Minitest::Test

  def test_get_collision_time_and_normal_colliding_vertically
    p = Nulu::Polygon.new(Nulu::Point.new(0, 0),
                          Nulu::Point.new(0, 4),
                          Nulu::Point.new(4, 4),
                          Nulu::Point.new(4, 0))
    q = Nulu::Polygon.new(Nulu::Point.new(2, 3),
                          Nulu::Point.new(5, 3),
                          Nulu::Point.new(5, 5),
                          Nulu::Point.new(2, 5))

    collision_time, collision_normal = Nulu::Collision::get_collision_time_and_normal(p, Nulu::Point.new(1, 0), q, Nulu::Point.new(0, 0))
    assert_equal 0, collision_time
    assert_equal nil, collision_normal
  end

  def test_get_collision_time_and_normal_colliding_horizontally
    p = Nulu::Polygon.new(Nulu::Point.new(0, 0),
                          Nulu::Point.new(0, 4),
                          Nulu::Point.new(4, 4),
                          Nulu::Point.new(4, 0))
    q = Nulu::Polygon.new(Nulu::Point.new(3, 2),
                          Nulu::Point.new(6, 2),
                          Nulu::Point.new(6, 4),
                          Nulu::Point.new(3, 4))

    collision_time, collision_normal = Nulu::Collision::get_collision_time_and_normal(p, Nulu::Point.new(1, 0), q, Nulu::Point.new(0, 0))
    assert_equal 0, collision_time
    assert_equal nil, collision_normal
  end

  def test_get_collision_time_and_normal_colliding_diagonally
    p = Nulu::Polygon.new(Nulu::Point.new(1, 0),
                          Nulu::Point.new(0, 1),
                          Nulu::Point.new(-1, 0),
                          Nulu::Point.new(0, -1))
    q = Nulu::Polygon.new(Nulu::Point.new(0 + 0.25, 0 + 0.25),
                          Nulu::Point.new(2 + 0.25, 0 + 0.25),
                          Nulu::Point.new(2 + 0.25, 2 + 0.25),
                          Nulu::Point.new(0 + 0.25, 2 + 0.25))
    collision_time, collision_normal = Nulu::Collision::get_collision_time_and_normal(p, Nulu::Point.new(1, 0), q, Nulu::Point.new(0, 0))
    assert_equal 0, collision_time
    assert_equal nil, collision_normal
  end

  def test_get_collision_time_and_normal_colliding_reverse_diagonally
    p = Nulu::Polygon.new(Nulu::Point.new(1, 0),
                          Nulu::Point.new(0, 1),
                          Nulu::Point.new(-1, 0),
                          Nulu::Point.new(0, -1))
    q = Nulu::Polygon.new(Nulu::Point.new(0, 0),
                          Nulu::Point.new(2, 0),
                          Nulu::Point.new(2, 2),
                          Nulu::Point.new(0, 2))
    collision_time, collision_normal = Nulu::Collision::get_collision_time_and_normal(q, Nulu::Point.new(1, 0), p, Nulu::Point.new(0, 0))
    assert_equal 0, collision_time
    assert_equal nil, collision_normal
  end


  def test_get_collision_time_and_normal_horizontal
    #   o
    #   oo
    #xxxooo
    #xxx   
    #xxx
    p = Nulu::Polygon.new(Nulu::Point.new(0, 0),
                          Nulu::Point.new(0, 2),
                          Nulu::Point.new(2, 2),
                          Nulu::Point.new(2, 0))
    q = Nulu::Polygon.new(Nulu::Point.new(3, 2),
                          Nulu::Point.new(3, 4),
                          Nulu::Point.new(5, 2))

    # non-collision
    collision_time, collision_normal = Nulu::Collision::get_collision_time_and_normal(p, Nulu::Vector.new(0, 0), q, Nulu::Vector.new(0, 0))
    assert_equal nil, collision_time
    assert_equal nil, collision_normal

    # eventual collision
    collision_time, collision_normal = Nulu::Collision::get_collision_time_and_normal(p, Nulu::Vector.new(2, 0), q, Nulu::Vector.new(0, 0))
    assert_equal 0.5, collision_time
    assert_equal Nulu::Point.new(1, 0), collision_normal

    # eventual collision, with non-zero y speed
    collision_time, collision_normal = Nulu::Collision::get_collision_time_and_normal(p, Nulu::Vector.new(2, 1), q, Nulu::Vector.new(0, 0))
    assert_equal 0.5, collision_time
    assert_equal Nulu::Point.new(1, 0), collision_normal

    # two bodies approaching
    collision_time, collision_normal = Nulu::Collision::get_collision_time_and_normal(p, Nulu::Vector.new(0.25, 1), q, Nulu::Vector.new(-0.25, 0))
    assert_equal 2.0, collision_time
    assert_equal Nulu::Point.new(1, 0), collision_normal

    # one body tailing the other
    collision_time, collision_normal = Nulu::Collision::get_collision_time_and_normal(p, Nulu::Vector.new(4, 1), q, Nulu::Vector.new(2, 0))
    assert_equal 0.5, collision_time
    assert_equal Nulu::Point.new(1, 0), collision_normal

    # one body tailing the other, but the other is too fast
    collision_time, collision_normal = Nulu::Collision::get_collision_time_and_normal(p, Nulu::Vector.new(4, 1), q, Nulu::Vector.new(5, 0))
    assert_equal nil, collision_time
    assert_equal nil, collision_normal

    # one body slowly tailing the other, and eventually colliding
    collision_time, collision_normal = Nulu::Collision::get_collision_time_and_normal(p, Nulu::Vector.new(2.1, 0), q, Nulu::Vector.new(2, 0))
    assert_in_delta 9.999, collision_time
    assert_equal Nulu::Point.new(1, 0), collision_normal

    # one body slowly tailing the other, but missing through y axis
    collision_time, collision_normal = Nulu::Collision::get_collision_time_and_normal(p, Nulu::Vector.new(2.1, 1), q, Nulu::Vector.new(2, 0))
    assert_equal nil, collision_time
    assert_equal nil, collision_normal

    # eventual collision by other body approaching
    collision_time, collision_normal = Nulu::Collision::get_collision_time_and_normal(p, Nulu::Vector.new(0, 0), q, Nulu::Vector.new(-2, -1))
    assert_equal 0.5, collision_time
    assert_equal Nulu::Point.new(1, 0), collision_normal

    # eventual collision by other body tailing the first one
    collision_time, collision_normal = Nulu::Collision::get_collision_time_and_normal(p, Nulu::Vector.new(-2, 0), q, Nulu::Vector.new(-2.5, 0))
    assert_equal 2.0, collision_time
    assert_equal Nulu::Point.new(1, 0), collision_normal
  end

  def test_get_collision_time_and_normal_vertical
    #ooooooo  
    #ooooooo
    #  
    #  xxx
    #  xxx   
    #  xxx
    p = Nulu::Polygon.new(Nulu::Point.new(2, 0),
                          Nulu::Point.new(4, 0),
                          Nulu::Point.new(4 , 2),
                          Nulu::Point.new(2, 2))
    q = Nulu::Polygon.new(Nulu::Point.new(0, 4),
                          Nulu::Point.new(6, 4),
                          Nulu::Point.new(6, 5),
                          Nulu::Point.new(0, 5))

    # both bodies static, not colliding
    assert_equal nil, Nulu::Collision::get_collision_time_and_normal(p, Nulu::Vector.new(0.0, 0.0), q, Nulu::Vector.new(0.0, 0.0))

    # no collision (but with one body moving horizontally)
    assert_equal nil, Nulu::Collision::get_collision_time_and_normal(p, Nulu::Vector.new(0.0, 0.0), q, Nulu::Vector.new(-1.0, 0.0))

    # vertical collision
    collision_time, collision_normal = Nulu::Collision::get_collision_time_and_normal(p, Nulu::Vector.new(0.0, 1.0), q, Nulu::Vector.new(0.0, 0))
    assert_equal 2.0, collision_time
    assert_equal Nulu::Point.new(0, 1), collision_normal

    # vertical collision with a little horizontal motion
    collision_time, collision_normal = Nulu::Collision::get_collision_time_and_normal(p, Nulu::Vector.new(0.0, 1.0), q, Nulu::Vector.new(1.0, 0))
    assert_equal 2.0, collision_time
    assert_equal Nulu::Point.new(0, 1), collision_normal

    # missing collision with both shapes moving horizontally
    assert_equal nil, Nulu::Collision::get_collision_time_and_normal(p, Nulu::Vector.new(0.0, 1.0), q, Nulu::Vector.new(10.0, 0))

    # colliding diagonally with both shapes moving horizontally
    collision_time, collision_normal = Nulu::Collision::get_collision_time_and_normal(p, Nulu::Vector.new(10.0, 1.0), q, Nulu::Vector.new(10.0, 0.5))
    assert_equal 4.0, collision_time
    assert_equal Nulu::Point.new(0, 1), collision_normal
  end
 
  def test_get_collision_time_and_normal_non_squares
    #    o
    #   ooo
    # x  o
    #xxx
    # x
    p = Nulu::Polygon.new(Nulu::Point.new(1, 0),
                          Nulu::Point.new(2, 1),
                          Nulu::Point.new(1, 2),
                          Nulu::Point.new(0, 1))
    q = Nulu::Polygon.new(Nulu::Point.new(4, 2),
                          Nulu::Point.new(5, 3),
                          Nulu::Point.new(4, 4),
                          Nulu::Point.new(3, 3))

    # static
    assert_equal nil, Nulu::Collision::get_collision_time_and_normal(p, Nulu::Vector.new(0.0, 0.0), q, Nulu::Vector.new(0.0, 0.0))

    # diagonal collision
    collision_time, collision_normal = Nulu::Collision::get_collision_time_and_normal(p, Nulu::Vector.new(1.0, 1.0), q, Nulu::Vector.new(0.0, 0.0))
    assert_equal 1.5, collision_time
    assert_equal Nulu::Point.new(1, 1).unit(), collision_normal

    # non-perfect diagonal collision
    collision_time, collision_normal = Nulu::Collision::get_collision_time_and_normal(p, Nulu::Vector.new(1.0, 1.0), q, Nulu::Vector.new(0.0, 0.1))
    assert_in_delta 1.578, collision_time
    assert_equal Nulu::Point.new(1, 1).unit(), collision_normal

    # non-collision by horizontal escape
    assert_equal nil, Nulu::Collision::get_collision_time_and_normal(p, Nulu::Vector.new(1.0, 1.0), q, Nulu::Vector.new(5.0, 0.0))
  end

  def test_border_collision
    # The edges of these test polygons are touching
    p = Nulu::Polygon.new(Nulu::Point.new(0, 0),
                         Nulu::Point.new(0, 1),
                          Nulu::Point.new(1, 1),
                          Nulu::Point.new(1, 0))
    p_velocity = Nulu::Point.new(0.0, 0.0)
    q = Nulu::Polygon.new(Nulu::Point.new(0, 1),
                         Nulu::Point.new(0, 2),
                          Nulu::Point.new(1, 2),
                          Nulu::Point.new(1, 1))
    q_velocity = Nulu::Point.new(0.0, 0.0)

    collision_time, collision_normal = Nulu::Collision::get_collision_time_and_normal(p, p_velocity, q, q_velocity)
    assert_equal 0, collision_time
    assert_equal nil, collision_normal
  end

  def test_corner_case_on_avoiding_collision
    # This is a reactive test against a specific bug.
    # It handles the corner case in an axis where the first shape is initially colliding,
    # and then stops colliding though relative velocity on the *negative side*.
    p = Nulu::Polygon.new(
      Nulu::Point.new(729.0, 249.0),
      Nulu::Point.new(799.0, 249.0),
      Nulu::Point.new(799.0, 351.0),
      Nulu::Point.new(729.0, 351.0))
    p_velocity = Nulu::Point.new(1.0, 2.0)

    q = Nulu::Polygon.new(
      Nulu::Point.new(800.0, 220.0),
      Nulu::Point.new(800.0, 250.0),
      Nulu::Point.new(1000.0, 250.0),
      Nulu::Point.new(1000.0, 220.0))
    q_velocity = Nulu::Point.new(0, 0)

    collision_time, collision_normal = Nulu::Collision::get_collision_time_and_normal(p, p_velocity, q, q_velocity)
    assert_equal nil, collision_time
    assert_equal nil, collision_normal
  end

end