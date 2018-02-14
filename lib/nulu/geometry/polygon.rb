module Nulu

  class Polygon
    ## Initialization
    def initialize(*vertex)
      @anchor = Point.new(0, 0)
      unless vertex.size() >= 3
        raise "Invalid initialization of Polygon (too few arguments)"
      end
      unless vertex[0].is_a?(Point)
        raise "Invalid initialization of Polygon (wrong argument type)"
      end
      @vertex = vertex
    end


    ## Accesors
    attr_accessor :anchor, :vertex

    def segments
      segments = Array.new
      (0...@vertex.size-1).each do |i|
        segments << Segment.new(@vertex[i], @vertex[i+1])
      end
      segments << Segment.new(@vertex.last, @vertex.first)
      return segments
    end

    def width
      max = -INF
      min = INF
      @vertex.each do |p|
        max = p.x if p.x > max
        min = p.x if p.x < min
      end
      return max - min
    end

    def height
      max = -INF
      min = INF
      @vertex.each do |p|
        max = p.y if p.y > max
        min = p.y if p.y < min
      end
      return max - min
    end

    def center
      @vertex.reduce(&:sum) / @vertex.size
    end
  end

end

