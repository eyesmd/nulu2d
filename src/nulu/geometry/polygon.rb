module Nulu

  class Polygon
    
    ## Initialization
    def initialize(*vertex)
      unless vertex.size() >= 3
        raise "Invalid initialization of Polygon (too few arguments)"
      end
      unless vertex[0].is_a?(Point)
        raise "Invalid initialization of Polygon (wrong argument type)"
      end
      @vertex = vertex
    end


    ## Accesors
    attr_reader :vertex

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
      @vertex.reduce(&:+) / @vertex.size
    end

    def left
      @vertex.map(&:x).min
    end

    def right
      @vertex.map(&:x).max
    end

    def bottom
      @vertex.map(&:y).min
    end

    def top
      @vertex.map(&:y).max
    end

    def center=(new_center)
      self.move(new_center - self.center)
    end

    def left=(new_left)
      self.move_x(new_left - self.left)
    end

    def right=(new_right)
      self.move_x(new_right - self.right)
    end

    def bottom=(new_bottom)
      self.move_y(new_bottom - self.bottom)
    end

    def top=(new_top)
      self.move_y(new_top - self.top)
    end


    ## Transformation
    def move(v)
      @vertex.map!{|p| p + v}
    end

    def move_x(ox)
      @vertex.each{|p| p.x += ox}
    end

    def move_y(oy)
      @vertex.each{|p| p.y += oy}
    end
  end

end

