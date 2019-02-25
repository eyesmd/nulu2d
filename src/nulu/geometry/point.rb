module Nulu

  class Point

    ## Initialization
    ## ++++++++++++++
    def initialize(x=0, y=0)
      @x = Float(x)
      @y = Float(y)
    end

    def self.make(args={})
      p = Point.new()
      if args[:angle] && args[:norm]
        p.x = Math::cos(args[:angle]) * Float(args[:norm])
        p.y = Math::sin(args[:angle]) * Float(args[:norm])
      else
        raise "Invalid construction of Point"
      end
      return p
    end


    ## Accessors
    ## +++++++++
    attr_accessor :x, :y
  
    def angle() # Normalized, [0..2PI]
      (Math::atan2(@y, @x) + 2*Math::PI) % (2*Math::PI)
    end
    
    def norm()
      Math::sqrt(@x**2 + @y**2)
    end
    
    def angle=(angle)
      direct_to(angle, self.norm)
    end
    
    def norm=(norm)
      direct_to(self.angle, norm)
    end
    
  
    ## Operators
    ## +++++++++
    def -@
      Point.new(-@x, -@y)
    end
    
    def +(p)
      Point.new(@x + p.x, @y + p.y)
    end
    
    def -(p)
      Point.new(@x - p.x, @y - p.y)
    end
    
    def *(arg) # Scalar product
      if arg.is_a?(Numeric)
        return Point.new(@x * arg, @y * arg)
      elsif arg.is_a?(Point)
        return @x * arg.x + @y * arg.y
      else
        raise "Invalid argument in point multiplication"
      end
    end

    def **(arg) # Vector product
      @x * arg.y - @y * arg.x
    end
    
    def /(scalar)
      self * (1.0/scalar)
    end
  
    def unit
      self / norm()
    end

    def rotated(angle)
      rotated_point = self.dup()
      rotated_point.direct_to(self.angle + angle, self.norm)
      return rotated_point
    end

    # 90 degrees to the right by default
    def perp(left=false)
      left ? Point.new(-@y, @x) : Point.new(@y, -@x)
    end

    def trimmed(scalar)
      trimmed_point = self.dup()
      trimmed_point.norm = Float(scalar) if norm > scalar
      return trimmed_point
    end

    def inverted()
      return -self
    end

    def inverted_x()
      return Point.new(-@x, @y)
    end

    def inverted_y()
      return Point.new(@x, -@y)
    end

    def sproject_to(p) # Scalar projection
      self * p.unit()
    end

    def vproject_to(p) # Vector projection
      p.unit() * sproject_to(p)
    end

    def decompose_into(v) # decomposes self into orthogonal vectors
      parallel_decomposition = vproject_to(v)
      return [parallel_decomposition, self - parallel_decomposition]
    end


    ## Mutators
    ## ++++++++
    def point_to(x, y)
      @x = Float(x)
      @y = Float(y)
    end
    
    def direct_to(angle, norm=1)
      @x = Math::cos(angle) * Float(norm)
      @y = Math::sin(angle) * Float(norm)
    end

    def zero
      @x = 0
      @y = 0
    end

    
    ## Comparisons
    ## +++++++++++
    def ==(p)
      (@x - p.x).abs < EPS && (@y - p.y).abs < EPS
    end
  
    def distance(other)
      other.distance_to_point(self)
    end

      def distance_to_point(other_point)
        (self - other_point).norm
      end

      def distance_to_segment(other_segment)
        # If we can trace a line perpendicular to the segment that contains
        # the point, then said direction is the shortest one. Otherwise, the
        # point is closest to one of the segments' endpoints.
        projected_a = other_segment.a.sproject_to(other_segment.direction)
        projected_b = other_segment.b.sproject_to(other_segment.direction)
        projected_point = self.sproject_to(other_segment.direction)

        if projected_a <= projected_b
          projected_min = projected_a
          projected_max = projected_b
        else
          projected_min = projected_b
          projected_max = projected_a
        end

        if projected_min <= projected_point && projected_point <= projected_max
          return (self.sproject_to(other_segment.direction.perp) - other_segment.a.sproject_to(other_segment.direction.perp)).abs
        else
          return [self.distance(other_segment.a), self.distance(other_segment.b)].min
        end
      end

    def parallel?(v)
      (self ** v).abs < EPS
    end
  
    def perpendicular?(v)
      (self * v).abs < EPS
    end

    def zero?
      @x.abs < EPS && @y.abs < EPS
    end
  end

end
