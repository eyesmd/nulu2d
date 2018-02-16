require "minitest/autorun"
require_relative "../lib/nulu"

class TestCollision < Minitest::Unit::TestCase
  def test_scalar_intersection_regular
    l1 = Nulu::Segment.make(:center => Nulu::Point.new(0, 0),
                            :direction => Nulu::Point.new(-0.5, -1))
    l2 = Nulu::Segment.make(:center => Nulu::Point.new(0, 3),
                            :direction => Nulu::Point.new(1, -1))
    t1, t2 = Nulu::Collision::scalar_intersection(l1, l2)
    assert_equal (-2), t1
    assert_equal 1, t2
    t2, t1 = Nulu::Collision::scalar_intersection(l2, l1)
    assert_equal (-2), t1
    assert_equal 1, t2
  end

  def test_scalar_intersection_parallel
    l1 = Nulu::Segment.make(:center => Nulu::Point.new(0, 3),
                            :direction => Nulu::Point.new(1, -1))
    l2 = Nulu::Segment.make(:center => Nulu::Point.new(1, 0),
                            :direction => Nulu::Point.new(1, -1))
    t1, _ = Nulu::Collision::scalar_intersection(l2, l1)
    assert_nil t1
    t1, _ = Nulu::Collision::scalar_intersection(l1, l1)
    assert_nil t1
  end

  def test_linear_intersection
    a = Nulu::Point.new(0, 1)
    b = Nulu::Point.new(1, 1)
    c = Nulu::Point.new(1, 0)
    d = Nulu::Point.new(0, 0)
    e = Nulu::Point.new(2, 2)
    s1 = Nulu::Segment.new(a, c)
    s2 = Nulu::Segment.new(d, e)
    assert_equal Nulu::Point.new(0.5, 0.5),
                 Nulu::Collision::linear_intersection(s1, s2)
    s1 = Nulu::Segment.new(d, c);
    s2 = Nulu::Segment.new(a, b);
    assert_nil Nulu::Collision::linear_intersection(s1, s2)
    s1 = Nulu::Segment.new(a, c)
    s2 = Nulu::Segment.new(e, b)
    assert_nil Nulu::Collision::linear_intersection(s1, s2)
  end

  def test_mtv_nil
    p = Nulu::Polygon.new(Nulu::Point.new(0, 0),
                          Nulu::Point.new(0, 2),
                          Nulu::Point.new(2, 2),
                          Nulu::Point.new(2, 0))
    q = Nulu::Polygon.new(Nulu::Point.new(3, 3),
                          Nulu::Point.new(3, 5),
                          Nulu::Point.new(4, 4),
                          Nulu::Point.new(5, 3))
    assert_nil Nulu::Collision::mtv(p, q)
  end

  def test_mtv_up
    p = Nulu::Polygon.new(Nulu::Point.new(0, 0),
                          Nulu::Point.new(0, 4),
                          Nulu::Point.new(4, 4),
                          Nulu::Point.new(4, 0))
    q = Nulu::Polygon.new(Nulu::Point.new(2, 3),
                          Nulu::Point.new(5, 3),
                          Nulu::Point.new(5, 5),
                          Nulu::Point.new(2, 5))
    assert nil != Nulu::Collision::mtv(p, q), "mtv shouldn't be nil"
    assert_equal Nulu::Point.new(0, 1),
                 Nulu::Collision::mtv(p, q)

  end

  def test_mtv_right
    p = Nulu::Polygon.new(Nulu::Point.new(0, 0),
                          Nulu::Point.new(0, 4),
                          Nulu::Point.new(4, 4),
                          Nulu::Point.new(4, 0))
    q = Nulu::Polygon.new(Nulu::Point.new(3, 2),
                          Nulu::Point.new(6, 2),
                          Nulu::Point.new(6, 4),
                          Nulu::Point.new(3, 4))
    assert nil != Nulu::Collision::mtv(p, q), "mtv shouldn't be nil"
    assert_equal Nulu::Point.new(1, 0),
                 Nulu::Collision::mtv(p, q)

  end

  def test_mtv_right_up
    p = Nulu::Polygon.new(Nulu::Point.new(1, 0),
                          Nulu::Point.new(0, 1),
                          Nulu::Point.new(-1, 0),
                          Nulu::Point.new(0, -1))
    q = Nulu::Polygon.new(Nulu::Point.new(0 + 0.25, 0 + 0.25),
                          Nulu::Point.new(2 + 0.25, 0 + 0.25),
                          Nulu::Point.new(2 + 0.25, 2 + 0.25),
                          Nulu::Point.new(0 + 0.25, 2 + 0.25))
    assert nil != Nulu::Collision::mtv(p, q), "mtv shouldn't be nil"
    assert_equal Nulu::Point.new(0.25, 0.25),
                 Nulu::Collision::mtv(p, q)
  end


  def test_mtv_reverse
    p = Nulu::Polygon.new(Nulu::Point.new(1, 0),
                          Nulu::Point.new(0, 1),
                          Nulu::Point.new(-1, 0),
                          Nulu::Point.new(0, -1))
    q = Nulu::Polygon.new(Nulu::Point.new(0, 0),
                          Nulu::Point.new(2, 0),
                          Nulu::Point.new(2, 2),
                          Nulu::Point.new(0, 2))
    assert nil != Nulu::Collision::mtv(q, p), "mtv shouldn't be nil"
    assert_equal Nulu::Point.new(-0.5, -0.5),
                 Nulu::Collision::mtv(q, p)
  end

  def test_contains_false
    shape = Nulu::Polygon.new(Nulu::Point.new(0, 1),
                              Nulu::Point.new(1, 0),
                              Nulu::Point.new(2, 0),
                              Nulu::Point.new(3, 1),
                              Nulu::Point.new(3, 2),
                              Nulu::Point.new(2, 3),
                              Nulu::Point.new(1, 3),
                              Nulu::Point.new(0, 2))
    point = Nulu::Point.new(0.5 - 0.1, 0.5 - 0.1)
    assert_equal false, Nulu::Collision::containing?(shape, point)
  end

  def test_contains_true
    shape = Nulu::Polygon.new(Nulu::Point.new(0, 1),
                              Nulu::Point.new(1, 0),
                              Nulu::Point.new(2, 0),
                              Nulu::Point.new(3, 1),
                              Nulu::Point.new(3, 2),
                              Nulu::Point.new(2, 3),
                              Nulu::Point.new(1, 3),
                              Nulu::Point.new(0, 2))
    point = Nulu::Point.new(0.5 + 0.1, 0.5 + 0.1)
    assert_equal true, Nulu::Collision::containing?(shape, point)
  end
end
