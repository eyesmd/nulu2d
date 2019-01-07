module Nulu

  class Entity

    ## Initialization
    def initialize(shape, mass, friction = 0.0, initial_velocity = Nulu::Vector.new(0, 0))
      @shape = shape
      @mass = Float(mass)
      @friction = Float(friction)
      @velocity = initial_velocity
    end


    ## Entity Accessors
    attr_accessor :velocity
    attr_accessor :mass, :friction


    ## Shape Readers
    def width() @shape.width() end  
    def height() @shape.height() end
    def center() @shape.center() end
    def left() @shape.left() end
    def right() @shape.right() end
    def top() @shape.top() end
    def bottom() @shape.bottom() end

    def shape # exposed for debug drawing!
      @shape
    end


    # Shape Modifiers
    # Should be used carefully, since they might mess with a World object!
    def center=(new_center) @shape.center = new_center end
    def left=(new_left) @shape.left = new_left end
    def right=(new_right) @shape.right = new_right end
    def top=(new_top) @shape.top = new_top end
    def bottom=(new_bottom) @shape.bottom = new_bottom end
    def move(offset) @shape.move(offset) end
    def move_x(offset_x) @shape.move_x(offset_x) end
    def move_y(offset_y) @shape.move_y(offset_y) end

  end
end
