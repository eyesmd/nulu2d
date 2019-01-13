module Nulu

  module Corporeal

    def width() @body.width() end  
    def height() @body.height() end
    def center() @body.center() end
    def left() @body.left() end
    def right() @body.right() end
    def top() @body.top() end
    def bottom() @body.bottom() end
    def center=(new_center) @body.center = new_center end
    def left=(new_left) @body.left = new_left end
    def right=(new_right) @body.right = new_right end
    def top=(new_top) @body.top = new_top end
    def bottom=(new_bottom) @body.bottom = new_bottom end
    def move(offset) @body.move(offset) end
    def move_x(offset_x) @body.move_x(offset_x) end
    def move_y(offset_y) @body.move_y(offset_y) end

    def shape() @body.shape end
    def shape=(new_shape) @body.shape = new_shape end

    def velocity() @body.velocity end
    def velocity=(new_velocity) @body.velocity = new_velocity end

    def mass() @body.mass end
    def mass=(new_mass) @body.mass = new_mass end

    def friction() @body.friction end
    def friction=(new_friction) @body.friction = new_friction end

    def frictionless() @body.frictionless end
    def frictionless=(new_frictionless) @body.frictionless = new_frictionless end

    def gravityless() @body.gravityless end
    def gravityless=(new_gravityless) @body.gravityless = new_gravityless end

    def normal() @body.normal end

  end
  
end