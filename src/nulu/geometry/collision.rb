module Nulu

  module Collision
    
    def self.colliding?(a, b)
      self.mtv(a, b)
    end

    # Returns the 'minimum translation vector' that must be applied to b to separate
    # a and b from each other, yielding nil if they're not intersecting.
    # The SAT algorithm is used (following Olivier Renault's guide, see README)
    # Note that it only works with *convex* polygons.
    def self.mtv(a, b)
      mtv = Point.new(INF, INF)
      axes = (a.segments + b.segments).map(&:direction)
                                      .map(&:perp).map(&:unit)
      axes.each do |axis|
        # shape projection
        mina, maxa = a.vertex.map{ |v| v * axis }.minmax
        minb, maxb = b.vertex.map{ |v| v * axis }.minmax

        o = 0       # overlap
        neg = false # direction (relative to axis)

        # ensuring mina < minb
        unless mina < minb
          mina, maxa = -maxa, -mina
          minb, maxb = -maxb, -minb
          neg = !neg
        end

        # find overlap
        if maxb <= maxa # containment
          o = maxb - minb
          if minb - mina < maxa - maxb
            o += minb - mina
          else
            o += maxa - maxb
            neg = !neg
          end
        elsif minb <= maxa # intersection
          o = maxa - minb
        else # separated
          return nil
        end

        # assure separation
        o += 1e-9

        # mtv update
        if o < mtv.norm
          mtv = axis * (neg ? -o : o)
        end
      end

      return mtv
    end

    # Returns whether 'shape' contains 'point'
    def self.containing?(shape, point)
      shape_point = shape.center
      shape.segments.each do |segment|
        orthogonal = segment.direction.perp.unit

        axis_projection = segment.a.sproject_to(orthogonal)
        shape_point_projection = shape_point.sproject_to(orthogonal)
        point_projection = point.sproject_to(orthogonal)

        shape_point_difference = shape_point_projection - axis_projection
        point_difference = point_projection - axis_projection

        if point_difference * shape_point_difference < 0 # different sign
          return false
        end
      end
      return true
    end

    # Returns the point on which two segments intersect, or nil if they don't
    def self.intersection(la, lb)
      t1, t2 = parametric_intersection(la, lb)
      if t1 && (t1 >= 0 - EPS && t1 <= 1 + EPS) &&
               (t2 >= 0 - EPS && t2 <= 1 + EPS)
        return la.a + (la.b - la.a) * t1
      else
        return nil
      end
    end

    # Returns a scalar for each segment, which is the value at which 
    # the parametric form of the segment must be evaluated to, to yield
    # the intersection between the segments
    # (from maxx.ru, the algo consists of solving a 2x2 equation of the
    # segments's parametric equations)
    def self.parametric_intersection(la, lb)
      c = la.center
      v = la.direction
      d = lb.center
      w = lb.direction

      ndet = v.x * w.y - v.y * w.x
      if ndet.abs > EPS
        return ((w.y * (d.x - c.x) - w.x * (d.y - c.y)) / ndet),
               ((v.y * (d.x - c.x) - v.x * (d.y - c.y)) / ndet)
      else
        return nil
      end
    end
  end

end
