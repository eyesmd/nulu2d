require "minitest/autorun"
require_relative "../lib/nulu"
require 'pry'

class TestXXX < Minitest::Unit::TestCase

  def test_zzz_colliding_up
    p = Nulu::Polygon.new(Nulu::Point.new(0, 0),
                          Nulu::Point.new(0, 4),
                          Nulu::Point.new(4, 4),
                          Nulu::Point.new(4, 0))
    q = Nulu::Polygon.new(Nulu::Point.new(2, 3),
                          Nulu::Point.new(5, 3),
                          Nulu::Point.new(5, 5),
                          Nulu::Point.new(2, 5))

    assert_equal 0, Nulu::XXX::get_collision_time(p, Nulu::Point.new(1, 0), q, Nulu::Point.new(0, 0))
  end

  def test_zzz_colliding_right
    p = Nulu::Polygon.new(Nulu::Point.new(0, 0),
                          Nulu::Point.new(0, 4),
                          Nulu::Point.new(4, 4),
                          Nulu::Point.new(4, 0))
    q = Nulu::Polygon.new(Nulu::Point.new(3, 2),
                          Nulu::Point.new(6, 2),
                          Nulu::Point.new(6, 4),
                          Nulu::Point.new(3, 4))

    assert_equal 0, Nulu::XXX::get_collision_time(p, Nulu::Point.new(1, 0), q, Nulu::Point.new(0, 0))
  end

  def test_zzz_colliding_right_up
    p = Nulu::Polygon.new(Nulu::Point.new(1, 0),
                          Nulu::Point.new(0, 1),
                          Nulu::Point.new(-1, 0),
                          Nulu::Point.new(0, -1))
    q = Nulu::Polygon.new(Nulu::Point.new(0 + 0.25, 0 + 0.25),
                          Nulu::Point.new(2 + 0.25, 0 + 0.25),
                          Nulu::Point.new(2 + 0.25, 2 + 0.25),
                          Nulu::Point.new(0 + 0.25, 2 + 0.25))
    assert_equal 0, Nulu::XXX::get_collision_time(p, Nulu::Point.new(1, 0), q, Nulu::Point.new(0, 0))
  end


  def test_zzz_colliding_reverse
    p = Nulu::Polygon.new(Nulu::Point.new(1, 0),
                          Nulu::Point.new(0, 1),
                          Nulu::Point.new(-1, 0),
                          Nulu::Point.new(0, -1))
    q = Nulu::Polygon.new(Nulu::Point.new(0, 0),
                          Nulu::Point.new(2, 0),
                          Nulu::Point.new(2, 2),
                          Nulu::Point.new(0, 2))
    assert_equal 0, Nulu::XXX::get_collision_time(q, Nulu::Point.new(1, 0), p, Nulu::Point.new(0, 0))
  end


  def test_get_collision_time_horizontal
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
    assert_equal nil, Nulu::XXX::get_collision_time(p, Nulu::Vector.new(0, 0), q, Nulu::Vector.new(0, 0))

    # future collision
    assert_equal 0.5, Nulu::XXX::get_collision_time(p, Nulu::Vector.new(2, 0), q, Nulu::Vector.new(0, 0))

    # future collision - with y speed
    assert_equal 0.5, Nulu::XXX::get_collision_time(p, Nulu::Vector.new(2, 1), q, Nulu::Vector.new(0, 0))

    # two bodies approaching
    assert_equal 2.0, Nulu::XXX::get_collision_time(p, Nulu::Vector.new(0.25, 1), q, Nulu::Vector.new(-0.25, 0))

    # one body tailing the other
    assert_equal 0.5, Nulu::XXX::get_collision_time(p, Nulu::Vector.new(4, 1), q, Nulu::Vector.new(2, 0))

    # one body 2 fast
    assert_equal nil, Nulu::XXX::get_collision_time(p, Nulu::Vector.new(4, 1), q, Nulu::Vector.new(5, 0))

    # one body tailing the other really slowly
    assert_in_delta 9.999, Nulu::XXX::get_collision_time(p, Nulu::Vector.new(2.1, 0), q, Nulu::Vector.new(2, 0))

    # one body tailing the other really slowly, but missing through y axis
    assert_equal nil, Nulu::XXX::get_collision_time(p, Nulu::Vector.new(2.1, 1), q, Nulu::Vector.new(2, 0))

    # future-collision by other body approaching
    assert_equal 0.5, Nulu::XXX::get_collision_time(p, Nulu::Vector.new(0, 0), q, Nulu::Vector.new(-2, -1))

    # future-collision by other body tailing the first one
    assert_equal 2.0, Nulu::XXX::get_collision_time(p, Nulu::Vector.new(-2, 0), q, Nulu::Vector.new(-2.5, 0))
  end

  def test_get_collision_time_vertical
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

    # static
    assert_equal nil, Nulu::XXX::get_collision_time(p, Nulu::Vector.new(0.0, 0.0), q, Nulu::Vector.new(0.0, 0.0))

    # no collision with horizontal motion
    assert_equal nil, Nulu::XXX::get_collision_time(p, Nulu::Vector.new(0.0, 0.0), q, Nulu::Vector.new(-1.0, 0.0))

    # vertical collision
    assert_equal 2.0, Nulu::XXX::get_collision_time(p, Nulu::Vector.new(0.0, 1.0), q, Nulu::Vector.new(0.0, 0))

    # vertical collision with little horizontal motion
    assert_equal 2.0, Nulu::XXX::get_collision_time(p, Nulu::Vector.new(0.0, 1.0), q, Nulu::Vector.new(1.0, 0))

    # miss with lots of horizontal motion
    assert_equal nil, Nulu::XXX::get_collision_time(p, Nulu::Vector.new(0.0, 1.0), q, Nulu::Vector.new(10.0, 0))

    # diagonal catch-up with lots of horizontal motion
    assert_equal 4.0, Nulu::XXX::get_collision_time(p, Nulu::Vector.new(10.0, 1.0), q, Nulu::Vector.new(10.0, 0.5))
  end

  def test_get_collision_time_non_squares
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
    assert_equal nil, Nulu::XXX::get_collision_time(p, Nulu::Vector.new(0.0, 0.0), q, Nulu::Vector.new(0.0, 0.0))

    # diagonal collision
    assert_equal 1.5, Nulu::XXX::get_collision_time(p, Nulu::Vector.new(1.0, 1.0), q, Nulu::Vector.new(0.0, 0.0))

    # non-perfect diagonal collision
    assert_in_delta 1.578, Nulu::XXX::get_collision_time(p, Nulu::Vector.new(1.0, 1.0), q, Nulu::Vector.new(0.0, 0.1))

    # non-collision by horizontal escape
    assert_equal nil, Nulu::XXX::get_collision_time(p, Nulu::Vector.new(1.0, 1.0), q, Nulu::Vector.new(5.0, 0.0))
  end

#  def test_outline_false_collision
#    p = Nulu::Polygon.new(Nulu::Point.new(662.0005500000011, 275.99999999999994),
#                          Nulu::Point.new(762.0005500000011, 275.99999999999994),
#                          Nulu::Point.new(762.0005500000011, 426.0),
#                          Nulu::Point.new(662.0005500000011, 426.0))
#    p_velocity = Nulu::Point.new(0.0, 4.0)
#
#    q = Nulu::Polygon.new(Nulu::Point.new(111.99945000000014, 426.0),
#                          Nulu::Point.new(911.9994499999989, 426.0),
#                          Nulu::Point.new(911.9994499999989, 626.0),
#                          Nulu::Point.new(111.99945000000014, 626.0))
#    q_velocity = Nulu::Point.new(0.0, 0.0)
#
#    assert_equal nil, Nulu::XXX::get_collision_time(p, p_velocity, q, q_velocity)
#    assert_false Nulu::Collision::colliding?(p, q)
#    assert_equal Nulu::Point.new(0, 0), Nulu::Collision::mtv(p, q)
#  end



end