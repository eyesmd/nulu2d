module Nulu

  class EntityController

    def initialize(world, entity, id)
      @world = world
      @entity = entity
      @id = id
    end

    # TODO: Look into 'Forwardable?'
    def width() @entity.width() end  
    def height() @entity.height() end
    def center() @entity.center() end
    def left() @entity.left() end
    def right() @entity.right() end
    def top() @entity.top() end
    def bottom() @entity.bottom() end
    def center=(new_center) @entity.center = new_center end
    def left=(new_left) @entity.left = new_left end
    def right=(new_right) @entity.right = new_right end
    def top=(new_top) @entity.top = new_top end
    def bottom=(new_bottom) @entity.bottom = new_bottom end
    def move(offset) @entity.move(offset) end
    def move_x(offset_x) @entity.move_x(offset_x) end
    def move_y(offset_y) @entity.move_y(offset_y) end

    def shape() @entity.shape end
    def shape=(new_shape) @entity.shape = new_shape end

    def velocity() @entity.velocity end
    def velocity=(new_velocity) @entity.velocity = new_velocity end

    def mass() @entity.mass end
    def mass=(new_mass) @entity.mass = new_mass end

    def friction() @entity.friction end
    def friction=(new_friction) @entity.friction = new_friction end

    def frictionless() @entity.frictionless end
    def frictionless=(new_frictionless) @entity.frictionless = new_frictionless end

    def normal
      @world.get_entity_normal(@id) || Nulu::Point.new(0, 0)
    end

  end
end