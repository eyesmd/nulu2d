require "minitest/autorun"
require_relative "../../src/nulu"

class TestXXX < Minitest::Test

  def test_nodes_accessors
    graph = Nulu::Graph.new()

    graph.add_node(:a)
    graph.add_node(:b)

    assert_equal 2, graph.node_count
    assert graph.is_node(:a)
    assert graph.is_node(:b)
    assert !graph.is_node(:c)
    assert_includes graph.nodes, :a
    assert_includes graph.nodes, :b
  end

  def test_graph_without_edges
    graph = Nulu::Graph.new()

    graph.add_node(:a)
    graph.add_node(:b)

    assert !graph.is_connected?(:a, :a)
    assert !graph.is_connected?(:b, :b)

    assert !graph.is_connected?(:a, :b)
    assert !graph.is_connected?(:b, :a)
  end

  def test_graph_with_edges
    graph = Nulu::Graph.new()

    graph.add_node(:a)
    graph.add_node(:b)
    graph.add_node(:c)

    graph.add_edge(:a, :a)
    graph.add_edge(:a, :c)

    assert graph.is_connected?(:a, :a)
    assert !graph.is_connected?(:b, :b)
    assert !graph.is_connected?(:c, :c)

    assert graph.is_connected?(:a, :c)
    assert graph.is_connected?(:c, :a)
    assert !graph.is_connected?(:a, :b)
    assert !graph.is_connected?(:b, :a)
    assert !graph.is_connected?(:b, :c)
    assert !graph.is_connected?(:c, :b)
  end

  def test_add_node_fails_when_node_limit_is_reached
    graph = Nulu::Graph.new(1)

    graph.add_node(:a)
    assert_raises(RuntimeError) { graph.add_node(:b) }
  end

  def test_add_node_does_not_fail_when_node_is_added_twice
    graph = Nulu::Graph.new()

    graph.add_node(:a)
    graph.add_node(:a)

    assert_equal graph.node_count, 1
    assert_includes graph.nodes, :a

    graph.add_edge(:a, :a)

    assert graph.is_connected?(:a, :a)
  end

  def test_add_edge_fails_when_node_does_not_exist
    graph = Nulu::Graph.new()   

    graph.add_node(:a)
    assert_raises(RuntimeError) { graph.add_edge(:a, :b) }
    assert_raises(RuntimeError) { graph.add_edge(:b, :a) }
    assert_raises(RuntimeError) { graph.add_edge(:b, :b) }
  end

  def test_is_connected_fails_when_node_does_not_exist
    graph = Nulu::Graph.new()   

    graph.add_node(:a)
    assert_raises(RuntimeError) { graph.is_connected?(:a, :b) }
    assert_raises(RuntimeError) { graph.is_connected?(:b, :a) }
    assert_raises(RuntimeError) { graph.is_connected?(:b, :b) }
  end

  def test_remove_edge_fails_when_node_does_not_exist
    graph = Nulu::Graph.new()   

    graph.add_node(:a)
    assert_raises(RuntimeError) { graph.remove_edge(:a, :b) }
    assert_raises(RuntimeError) { graph.remove_edge(:b, :a) }
    assert_raises(RuntimeError) { graph.remove_edge(:b, :b) }
  end

  def test_each_connected_pair
    graph = Nulu::Graph.new()

    graph.add_node(:a)
    graph.add_node(:b)
    graph.add_node(:c)

    graph.add_edge(:a, :a)
    graph.add_edge(:a, :b)
    graph.add_edge(:a, :c)
    graph.add_edge(:b, :b)

    assert_connected_pairs_are(graph, [ [:a,:a], [:a,:b], [:a,:c], [:b,:b] ])
  end

  def test_inverted_graph
    graph = Nulu::Graph.new(10, true)

    graph.add_node(:a)
    graph.add_node(:b)

    graph.remove_edge(:a, :a)

    assert !graph.is_connected?(:a, :a)
    assert graph.is_connected?(:b, :b)
    assert graph.is_connected?(:a, :b)
    assert graph.is_connected?(:b, :a)
  end


  # Helpers

  def assert_connected_pairs_are(graph, expected_pairs)
    actual_pairs = []
    graph.each_connected_pair do |a, b|
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