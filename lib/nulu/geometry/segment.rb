module Nulu

  class Segment
    ## Initialization
    def initialize(a=Point.new(), b=Point.new())
      @a = a
      @b = b
    end

    def self.make(args={})
      s = Segment.new()
      if args[:center] && args[:direction]
        s.a = args[:center]
        s.b = args[:center] + args[:direction]
      else
        raise "Invalid construction of Segment (wrong Hash)"
      end
      return s
    end

  
    ## Accessors
    attr_accessor :a, :b
  
    def center()
      @a
    end

    def direction()
      @b - @a
    end


    ## Comparisons
    def ==(seg)
      (@a == seg.a && @b == seg.b) || (@a == seg.b && @b == seg.a)
    end

    def parallel?(seg)
      self.direction.parallel?(seg.direction)
    end
  
    def perpendicular?(seg)
      self.direction.perpendicular?(seg.direction)
    end
  end
end 
