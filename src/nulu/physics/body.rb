module Nulu

  class Body

    attr_reader   :world, :collision_group, :id
    attr_reader   :shape
    attr_accessor :velocity
    attr_accessor :mass, :friction
    attr_accessor :frictionless, :gravityless

    def initialize(world, shape, mass, friction = 0.0, collision_group = :nulu_body_default)
      @world = world
      @collision_group = collision_group
      @id = world.add_body(self, collision_group)

      @shape = shape
      @mass = Float(mass)
      @friction = Float(friction)
      @velocity = Nulu::Vector.new(0, 0)
      @frictionless = false
      @gravityless = false
    end

    def width() @shape.width() end  
    def height() @shape.height() end
    def center() @shape.center() end
    def left() @shape.left() end
    def right() @shape.right() end
    def top() @shape.top() end
    def bottom() @shape.bottom() end
    def center=(new_center) @shape.center = new_center end
    def left=(new_left) @shape.left = new_left end
    def right=(new_right) @shape.right = new_right end
    def top=(new_top) @shape.top = new_top end
    def bottom=(new_bottom) @shape.bottom = new_bottom end
    def move(offset) @shape.move(offset) end
    def move_x(offset_x) @shape.move_x(offset_x) end
    def move_y(offset_y) @shape.move_y(offset_y) end

    def apply_velocity(delta)
      @shape.move(@velocity * delta)
    end

    def normal
      @world.get_body_normal(@id) || Nulu::Point.new(0, 0)
    end

  end
end
