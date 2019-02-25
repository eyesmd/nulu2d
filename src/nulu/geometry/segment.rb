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

    # TODO: Change the name of this method
    # TODO: Also, I do want a method called direction, but that returns (@b - @a).unit
    def direction()
      @b - @a
    end


    ## Comparisons
    def ==(seg)
      (@a == seg.a && @b == seg.b) || (@a == seg.b && @b == seg.a)
    end

    def distance(other)
      other.distance_to_segment(self)
    end

      def distance_to_point(other_point)
        other_point.distance_to_segment(self)
      end

      def distance_to_segment(other_segment)
        # It can be proven that unless both segments are parallel,
        # the shortest segment joining them touches an endpoint
        return [
          self.a.distance_to_segment(other_segment),
          self.b.distance_to_segment(other_segment),
          other_segment.a.distance_to_segment(self),
          other_segment.b.distance_to_segment(self)
        ].min
      end

    def parallel?(seg)
      self.direction.parallel?(seg.direction)
    end
  
    def perpendicular?(seg)
      self.direction.perpendicular?(seg.direction)
    end
  end
end 
