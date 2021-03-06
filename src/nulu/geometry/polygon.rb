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

    # Source: https://en.wikipedia.org/wiki/Centroid#Centroid_of_a_polygon
    def centroid()
      signed_area = 0.0
      centroid = Nulu::Point.new(0, 0)

      (0...@vertex.size-1).each do |i|
        centroid += (@vertex[i] + @vertex[i+1]) * (@vertex[i] ** @vertex[i+1])
        signed_area += @vertex[i] ** @vertex[i+1]
      end
      signed_area += @vertex.last ** @vertex.first
      centroid += (@vertex.last + @vertex.first) * (@vertex.last ** @vertex.first)

      signed_area /= 2.0
      centroid /= (6.0 * signed_area)

      return centroid
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

    def rotate_around(angle, anchor)
      @vertex = @vertex.map { |v| (v - anchor).rotated(angle) + anchor }
    end

    def rotate(angle)
      rotate_around(angle, self.centroid)
    end


    ## Comparisons
    ## +++++++++++
    def ==(other)
      # It yields false on translated or rotated polygons!
      # Supposes no repeated points
      return false unless self.vertex.size == other.vertex.size
      vertex_size = self.vertex.size

      offset = nil
      (0...vertex_size).each do |i|
        if self.vertex[0] == other.vertex[i]
          offset = i
          break
        end
      end

      return false unless offset

      (0...vertex_size).all? do |i|
        self.vertex[i] == other.vertex[(offset + i) % vertex_size]
      end ||
      (0...vertex_size).all? do |i|
        self.vertex[i] == other.vertex[(offset - i) % vertex_size]
      end
    end

  end

end

