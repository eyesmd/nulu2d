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
    
    # Scalar product
    def *(arg)
      if arg.is_a?(Numeric)
        return Point.new(@x * arg, @y * arg)
      elsif arg.is_a?(Point)
        return @x * arg.x + @y * arg.y
      else
        raise "Invalid argument in point multiplication"
      end
    end

    # Vector product
    def **(arg)
      @x * arg.y - @y * arg.x
    end
    
    def /(scalar)
      self * (1.0/scalar)
    end
  
    def unit
      self / norm()
    end

    def rotate(angle)
      rotated_point = self.dup()
      rotated_point.direct_to(self.angle + angle, self.norm)
      return rotated_point
    end

    # 90 degrees to the right by default
    def perp(left=false)
      left ? Point.new(-@y, @x) : Point.new(@y, -@x)
    end

    def trim(scalar)
      trimmed_point = self.dup()
      trimmed_point.norm = Float(scalar) if norm > scalar
      return trimmed_point
    end

    def invert()
      return -self
    end

    def invert_x()
      return Point.new(-@x, @y)
    end

    def invert_y()
      return Point.new(@x, -@y)
    end

    # Scalar projection
    def sproject_to(p)
      self * p.unit()
    end

    # Vector projection
    def vproject_to(p)
      p.unit() * sproject_to(p)
    end

    # decomposes self into orthogonal vectors
    # [parallel to 'v', perpendicular to 'v']
    def decompose_into(v)
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
  
    def distance(p)
      (self - p).norm
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
