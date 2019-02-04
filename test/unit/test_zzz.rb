require "minitest/autorun"
require_relative "../../src/nulu"

class TestZZZ < Minitest::Test

  def test_initialize_zzz
    zzz = Nulu::ZZZ.new(shape: Nulu::Rectangle.new(1, 1), mass: 2.0, inertia: 1.0)
    assert_equal Nulu::Rectangle.new(1, 1), zzz.shape
    assert_equal 2.0, zzz.mass
    assert_equal 0.0, zzz.orientation
    assert_equal Nulu::Vector.new(0, 0), zzz.position
  end

  def test_add_force_to_cm
    zzz = Nulu::ZZZ.new(shape: Nulu::Rectangle.new(1, 1), mass: 3.0, inertia: 1.0)
    zzz.add_force(Nulu::Vector.new(1.0, 0.0))
    zzz.add_force(Nulu::Vector.new(0.0, 1.0))

    assert_equal Nulu::Vector.new(1.0, 1.0), zzz.net_force
    assert_equal zzz.net_force, zzz.linear_acceleration * zzz.mass # Newton
  end

  def test_3
    zzz = Nulu::ZZZ.new(
      shape: Nulu::Rectangle.new(2, 2),
      position: Nulu::Point.new(-1, -1),
      mass: 3.0,
      inertia: 1.0)
    zzz.add_force_at(Nulu::Vector.new(1.0, 0.0),  Nulu::Point.new(-1, 0))
    zzz.add_force_at(Nulu::Vector.new(1.0, 0.0),  Nulu::Point.new(1, 0))

    assert_equal zzz.net_force, zzz.linear_acceleration * zzz.mass # Newton
  end

  def test_4
    zzz = Nulu::ZZZ.new(
      shape: Nulu::Rectangle.new(2, 2),
      position: Nulu::Point.new(-1, -1),
      mass: 3.0,
      inertia: 1.0)
    zzz.add_force_at(Nulu::Vector.new(1.0, 0.0),  Nulu::Point.new(-1, -1))

    assert_equal zzz.torque, 1.0

    assert_equal zzz.net_force, zzz.linear_acceleration * zzz.mass
    assert_equal zzz.torque, zzz.angular_acceleration * zzz.inertia
  end

  def test_5
    zzz = Nulu::ZZZ.new(
      shape: Nulu::Rectangle.new(2, 2),
      position: Nulu::Point.new(-1, -1),
      mass: 3.0,
      inertia: 1.0)
    zzz.add_force_at(Nulu::Vector.new(1.0, 0.0),  Nulu::Point.new(-1, -1))
    zzz.clear_forces()

    assert_equal zzz.torque, 0.0
    assert_equal zzz.net_force, Nulu::Vector.new(0, 0)

    assert_equal zzz.net_force, zzz.linear_acceleration * zzz.mass
    assert_equal zzz.torque, zzz.angular_acceleration * zzz.inertia
  end

end