module Nulu

  class Body

    def initialize(world, free_body, id)
      @world = world
      @free_body = free_body
      @id = id
    end

    # TODO: Look into 'Forwardable?'
    def width() @free_body.width() end  
    def height() @free_body.height() end
    def center() @free_body.center() end
    def left() @free_body.left() end
    def right() @free_body.right() end
    def top() @free_body.top() end
    def bottom() @free_body.bottom() end
    def center=(new_center) @free_body.center = new_center end
    def left=(new_left) @free_body.left = new_left end
    def right=(new_right) @free_body.right = new_right end
    def top=(new_top) @free_body.top = new_top end
    def bottom=(new_bottom) @free_body.bottom = new_bottom end
    def move(offset) @free_body.move(offset) end
    def move_x(offset_x) @free_body.move_x(offset_x) end
    def move_y(offset_y) @free_body.move_y(offset_y) end

    def shape() @free_body.shape end
    def shape=(new_shape) @free_body.shape = new_shape end

    def velocity() @free_body.velocity end
    def velocity=(new_velocity) @free_body.velocity = new_velocity end

    def mass() @free_body.mass end
    def mass=(new_mass) @free_body.mass = new_mass end

    def friction() @free_body.friction end
    def friction=(new_friction) @free_body.friction = new_friction end

    def frictionless() @free_body.frictionless end
    def frictionless=(new_frictionless) @free_body.frictionless = new_frictionless end

    def normal
      @world.get_body_normal(@id) || Nulu::Point.new(0, 0)
    end

  end
end