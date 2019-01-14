require "minitest/autorun"
require_relative "../src/nulu"

class TestCollisionEnabler < Minitest::Test

  def test_groupless_objects_are_collidable_by_default
    enabler = Nulu::CollisionEnabler.new()

    a, b, c = new_shapes(3)

    enabler.add(a)
    enabler.add(b)
    enabler.add(c)

    assert_collidable_pairs_are(enabler, [[a, b], [a, c], [b, c]])
  end

  def test_groups_are_collidable_by_default
    enabler = Nulu::CollisionEnabler.new()    

    a, b = new_shapes(2)

    enabler.add(a, :character)
    enabler.add(b, :character)

    assert_collidable_pairs_are(enabler, [[a, b]])
  end

  def test_groups_can_be_marked_as_non_collidable
    enabler = Nulu::CollisionEnabler.new()    

    a, b = new_shapes(2)

    enabler.add(a, :character)
    enabler.add(b, :character)

    enabler.disable_collision_within(:character)

    assert_collidable_pairs_are(enabler, [])
  end


  def test_groups_can_be_marked_as_collidable
    enabler = Nulu::CollisionEnabler.new()    

    a, b = new_shapes(2)

    enabler.add(a, :character)
    enabler.add(b, :character)

    enabler.disable_collision_within(:character)
    enabler.enable_collision_within(:character)

    assert_collidable_pairs_are(enabler, [[a, b]])
  end

  def test_groups_can_be_marked_before_objects_are_added
    enabler = Nulu::CollisionEnabler.new()    

    enabler.disable_collision_within(:character)

    a, b = new_shapes(2)

    enabler.add(a, :character)
    enabler.add(b, :character)

    assert_collidable_pairs_are(enabler, [])
  end

  def test_group_pairs_are_collidable_by_default
    enabler = Nulu::CollisionEnabler.new()

    a, b = new_shapes(2)
    enabler.add(a, :blue)
    enabler.add(b, :red)

    assert_collidable_pairs_are(enabler, [[a, b]])
  end

  def test_group_pairs_can_be_marked_as_non_collidable
    enabler = Nulu::CollisionEnabler.new()

    a, b = new_shapes(2)
    enabler.add(a, :blue)
    enabler.add(b, :red)

    enabler.disable_collision_between(:red, :blue)

    assert_collidable_pairs_are(enabler, [])
  end

  def test_group_pairs_can_be_marked_as_collidable
    enabler = Nulu::CollisionEnabler.new()

    a, b = new_shapes(2)
    enabler.add(a, :blue)
    enabler.add(b, :red)

    enabler.disable_collision_between(:red, :blue)
    enabler.enable_collision_between(:red, :blue)

    assert_collidable_pairs_are(enabler, [[a, b]])
  end

  def test_group_pairs_can_be_marked_before_objects_are_added
    enabler = Nulu::CollisionEnabler.new()

    enabler.disable_collision_between(:red, :blue)

    a, b = new_shapes(2)
    enabler.add(a, :blue)
    enabler.add(b, :red)

    assert_collidable_pairs_are(enabler, [])
  end

  def test_groups_can_be_marked_as_non_collidable_with_multiple_groups
    enabler = Nulu::CollisionEnabler.new()

    a, b, c, d = new_shapes(4)
    enabler.add(a, :blue)
    enabler.add(b, :blue)
    enabler.add(c, :red)
    enabler.add(d, :red)

    enabler.disable_collision_within(:blue)

    assert_collidable_pairs_are(enabler, [[c,d], [a,c], [a,d], [b,c], [b,d]])
  end

  def test_group_pairs_can_be_marked_as_non_collidable_with_multiple_pairs
    enabler = Nulu::CollisionEnabler.new()

    a, b, c = new_shapes(3)
    enabler.add(a, :a)
    enabler.add(b, :b)
    enabler.add(c, :c)

    enabler.disable_collision_between(:a, :c)

    assert_collidable_pairs_are(enabler, [[b,a], [b,c]])
  end

  def test_complex
    enabler = Nulu::CollisionEnabler.new()

    a, b, c, d, e, f, g, h = new_shapes(8)
    enabler.add(a, :allies)
    enabler.add(b, :enemies)
    enabler.add(c, :enemies)
    enabler.add(d, :stage)
    enabler.add(e, :stage)
    enabler.add(f, :stage)
    enabler.add(g, :stage)
    enabler.add(h, :objects)

    enabler.disable_collision_within(:stage)
    enabler.disable_collision_within(:objects)
    enabler.disable_collision_between(:objects, :stage)
    enabler.disable_collision_between(:objects, :enemies)

    expected_collidable_pairs = []
    expected_collidable_pairs << [a, b] << [a, c] << [a, d] << [a, e] << [a, f] << [a, g] << [a, h] # ally with everyone
    expected_collidable_pairs << [b, d] << [b, e] << [b, f] << [b, g] # enemy b with stage
    expected_collidable_pairs << [c, d] << [c, e] << [c, f] << [c, g] # enemy c with stage
    expected_collidable_pairs << [b, c] # enemies within themselves

    assert_collidable_pairs_are(enabler, expected_collidable_pairs)
  end


  # Helpers

  def new_shape()
    Nulu::Rectangle.new(1, 1)
  end

  def new_shapes(count)
    Array.new(count) { new_shape() }
  end

  def assert_collidable_pairs_are(enabler, expected_pairs)
    actual_pairs = []
    enabler.each_collidable_pair do |a, b|
      actual_pairs << [a, b]
    end

    assert_equal expected_pairs.size, actual_pairs.size, "Assertion failed: Wrong quantity of collidable pairs"
    actual_pairs.each do |pair|
      expected_count = expected_pairs.count { |e_pair| equal_pairs?(pair, e_pair) }
      actual_count = actual_pairs.count { |a_pair| equal_pairs?(pair, a_pair) }
      assert_equal expected_count, actual_count, "Assertion failed: Miscount of a pair"
    end
  end

  def equal_pairs?(pair_a, pair_b)
    (pair_a[0] == pair_b[0] && pair_a[1] == pair_b[1]) ||
    (pair_a[1] == pair_b[0] && pair_a[0] == pair_b[1])
  end

end