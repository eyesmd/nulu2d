require "minitest/autorun"
require_relative "../src/nulu"

class TestXXX < Minitest::Test

  def test_1
    xxx = Nulu::XXX.new()

    a, b, c = new_shapes(3)

    xxx.add(a)
    xxx.add(b)
    xxx.add(c)

    assert_collidable_pairs_are(xxx, [[a, b], [a, c], [b, c]])
  end

  def test_2
    xxx = Nulu::XXX.new()    

    a, b = new_shapes(2)

    xxx.add(a, :character)
    xxx.add(b, :character)

    assert_collidable_pairs_are(xxx, [[a, b]])
  end

  def test_3
    xxx = Nulu::XXX.new()    

    a, b = new_shapes(2)

    xxx.add(a, :character)
    xxx.add(b, :character)

    xxx.disable_collision_within(:character)

    assert_collidable_pairs_are(xxx, [])
  end


  def test_3b
    xxx = Nulu::XXX.new()    

    a, b = new_shapes(2)

    xxx.add(a, :character)
    xxx.add(b, :character)

    xxx.disable_collision_within(:character)
    xxx.enable_collision_within(:character)

    assert_collidable_pairs_are(xxx, [[a, b]])
  end

  def test_3c
    xxx = Nulu::XXX.new()    

    xxx.disable_collision_within(:character)

    a, b = new_shapes(2)

    xxx.add(a, :character)
    xxx.add(b, :character)

    assert_collidable_pairs_are(xxx, [])
  end

  def test_4
    xxx = Nulu::XXX.new()

    a, b = new_shapes(2)
    xxx.add(a, :blue)
    xxx.add(b, :red)

    assert_collidable_pairs_are(xxx, [[a, b]])
  end

  def test_5
    xxx = Nulu::XXX.new()

    a, b = new_shapes(2)
    xxx.add(a, :blue)
    xxx.add(b, :red)

    xxx.disable_collision_between(:red, :blue)

    assert_collidable_pairs_are(xxx, [])
  end

  def test_5b
    xxx = Nulu::XXX.new()

    a, b = new_shapes(2)
    xxx.add(a, :blue)
    xxx.add(b, :red)

    xxx.disable_collision_between(:red, :blue)
    xxx.enable_collision_between(:red, :blue)

    assert_collidable_pairs_are(xxx, [[a, b]])
  end

  def test_5c
    xxx = Nulu::XXX.new()

    xxx.disable_collision_between(:red, :blue)

    a, b = new_shapes(2)
    xxx.add(a, :blue)
    xxx.add(b, :red)

    assert_collidable_pairs_are(xxx, [])
  end

  # multiple withins
  def test_6
    xxx = Nulu::XXX.new()

    a, b, c, d = new_shapes(4)
    xxx.add(a, :blue)
    xxx.add(b, :blue)
    xxx.add(c, :red)
    xxx.add(d, :red)

    xxx.disable_collision_within(:blue)

    assert_collidable_pairs_are(xxx, [[c,d], [a,c], [a,d], [b,c], [b,d]])
  end

  # multiple betweens
  def test_7
    xxx = Nulu::XXX.new()

    a, b, c = new_shapes(3)
    xxx.add(a, :a)
    xxx.add(b, :b)
    xxx.add(c, :c)

    xxx.disable_collision_between(:a, :c)

    assert_collidable_pairs_are(xxx, [[b,a], [b,c]])
  end

  def 

  # big_test
  def test_big
    xxx = Nulu::XXX.new()

    a, b, c, d, e, f, g, h = new_shapes(8)
    xxx.add(a, :allies)
    xxx.add(b, :enemies)
    xxx.add(c, :enemies)
    xxx.add(d, :stage)
    xxx.add(e, :stage)
    xxx.add(f, :stage)
    xxx.add(g, :stage)
    xxx.add(h, :objects)

    xxx.disable_collision_within(:stage)
    xxx.disable_collision_within(:objects)
    xxx.disable_collision_between(:objects, :stage)
    xxx.disable_collision_between(:objects, :enemies)

    expected_collidable_pairs = []
    expected_collidable_pairs << [a, b] << [a, c] << [a, d] << [a, e] << [a, f] << [a, g] << [a, h] # ally with everyone
    expected_collidable_pairs << [b, d] << [b, e] << [b, f] << [b, g] # enemy b with stage
    expected_collidable_pairs << [c, d] << [c, e] << [c, f] << [c, g] # enemy c with stage
    expected_collidable_pairs << [b, c] # enemies within themselves

    assert_collidable_pairs_are(xxx, expected_collidable_pairs)
  end


  # Helpers

  def new_shape()
    Nulu::Rectangle.new(1, 1)
  end

  def new_shapes(count)
    Array.new(count) { new_shape() }
  end

  def assert_collidable_pairs_are(xxx, expected_pairs)
    actual_pairs = []
    xxx.each_collidable_pair do |a, b|
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