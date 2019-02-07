require "minitest/autorun"
require_relative "../../src/nulu"

class TestZZZ < Minitest::Test

  def test_initialize_zzz
    zzz = Nulu::ZZZ.new(shape: Nulu::Rectangle.new(1, 1), mass: 2.0, inertia: 1.0)
    assert_equal Nulu::Rectangle.new(1, 1), zzz.shape
    assert_equal 2.0, zzz.mass
  end

  def test_add_force_to_cm
    zzz = Nulu::ZZZ.new(shape: Nulu::Rectangle.new(1, 1), mass: 3.0, inertia: 1.0)
    zzz.add_force(Nulu::Vector.new(1.0, 0.0))
    zzz.add_force(Nulu::Vector.new(0.0, 1.0))

    assert_equal Nulu::Vector.new(1.0, 1.0), zzz.net_force
    assert_equal zzz.net_force, zzz.linear_acceleration * zzz.mass # Newton
  end

  def test_add_force_at_point_without_torque
    zzz = Nulu::ZZZ.new(
      shape: Nulu::Rectangle.new(2, 2),
      mass: 3.0,
      inertia: 1.0)
    zzz.move(Nulu::Point.new(-1, -1))
    zzz.add_force_at(Nulu::Vector.new(1.0, 0.0),  Nulu::Point.new(-1, 0))
    zzz.add_force_at(Nulu::Vector.new(1.0, 0.0),  Nulu::Point.new(1, 0))

    assert_equal Nulu::Vector.new(2.0, 0.0), zzz.net_force
    assert_equal 0, zzz.torque

    assert_equal zzz.net_force, zzz.linear_acceleration * zzz.mass # Newton
    assert_equal zzz.torque, zzz.angular_acceleration * zzz.inertia
  end

  def test_add_force_at_point_with_torque
    zzz = Nulu::ZZZ.new(
      shape: Nulu::Rectangle.new(2, 2),
      mass: 3.0,
      inertia: 1.0)
    zzz.shape.move(Nulu::Point.new(-1, -1))
    zzz.add_force_at(Nulu::Vector.new(1.0, 0.0),  Nulu::Point.new(-1, -1))

    assert_equal Nulu::Vector.new(1.0, 0.0), zzz.net_force
    assert_equal zzz.torque, 1.0

    assert_equal zzz.net_force, zzz.linear_acceleration * zzz.mass
    assert_equal zzz.torque, zzz.angular_acceleration * zzz.inertia
  end

  def test_clear_forces
    zzz = Nulu::ZZZ.new(
      shape: Nulu::Rectangle.new(2, 2),
      mass: 3.0,
      inertia: 1.0)
    zzz.move(Nulu::Point.new(-1, -1))

    zzz.add_force_at(Nulu::Vector.new(1.0, 0.0),  Nulu::Point.new(-1, -1))
    zzz.clear_forces()

    assert_equal zzz.net_force, Nulu::Vector.new(0, 0)
    assert_equal zzz.torque, 0.0

    assert_equal zzz.net_force, zzz.linear_acceleration * zzz.mass
    assert_equal zzz.torque, zzz.angular_acceleration * zzz.inertia
  end

end