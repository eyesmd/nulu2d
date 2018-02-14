module Nulu

  class Point
    ## Initialization
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
    attr_accessor :x, :y
  
    def angle() # Normalized, [0..2PI]
      (Math::atan2(@y, @x) + 2*Math::PI) % (2*Math::PI)
    end
    
    def norm()
      Math::sqrt(@x**2 + @y**2)
    end
    
    def angle=(angle)
      direct_to(angle, norm())
    end
    
    def norm=(norm)
      direct_to(angle(), norm)
    end
    
  
    ## Operators
    def -@
      Point.new(-@x, -@y)
    end
    
    def +(p)
      Point.new(@x + p.x, @y + p.y)
    end
    
    def -(p)
      self + (-p)
    end
    
    def *(arg)
      if arg.is_a?(Numeric)
        return Point.new(@x * arg, @y * arg)
      elsif arg.is_a?(Point)
        return @x * arg.x + @y * arg.y
      else
        raise "Invalid argument in point multiplication"
      end
    end

    def **(arg)
      return @x * arg.y - @y * arg.x
    end
    
    def /(scalar)
      self * (1.0/scalar)
    end
    
    def point_to(x, y)
      @x = Float(x)
      @y = Float(y)
    end
    
    def direct_to(angle, norm=1)
      @x = Math::cos(angle) * Float(norm)
      @y = Math::sin(angle) * Float(norm)
    end
    
    def apply(p)
      @x += p.x
      @y += p.y
    end
  
    def unit()
      self / norm()
    end

    # 90 degrees to the right
    def perp(left=false)
      if left
        Point.new(-@y, @x)
      else
        Point.new(@y, -@x)
      end
    end

    def zero?()
      @x.abs < EPS && @y.abs < EPS
    end

    def sproject(p)
      self * p.unit()
    end

    def vproject(p)
      p.unit() * sproject(p)
    end

    def trim(scalar)
      self.norm = Float(scalar) if norm > scalar
    end

    def sum(b)
      self + b
    end

    
    ## Comparisons
    def ==(p)
      (@x - p.x).abs < EPS && (@y - p.y).abs < EPS
    end
  
    def distance(p)
      (self - p).norm
    end
  end

end
