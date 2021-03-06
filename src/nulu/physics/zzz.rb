module Nulu

  class ZZZ

    attr_reader   :shape
    attr_reader   :mass, :linear_velocity
    attr_reader   :inertia, :angular_velocity

    def initialize(shape:, mass:, inertia:)
      @shape = shape
      @mass = mass
      @inertia = inertia
      @forces = []
      @torque = 0.0

      @linear_velocity = Nulu::Vector.new(0, 0)
      @angular_velocity = 0.0
    end


    def move(offset) @shape.move(offset) end
    def move_x(offset_x) @shape.move_x(offset_x) end
    def move_y(offset_y) @shape.move_y(offset_y) end
    def rotate_around(angle, anchor) @shape.rotate_around(angle, anchor) end
    def rotate(angle) @shape.rotate(angle) end


    def center_of_mass
      shape.centroid
    end
    

    def add_force(force)
      @forces << force
    end

    def add_force_at(force, application_point)
      @forces << force
      @torque += force * (application_point - self.center_of_mass).perp(true)
    end

    def clear_forces()
      @forces.clear()
      @torque = 0.0
    end


    def net_force()
      @forces.empty? ? Nulu::Vector.new(0, 0) : @forces.reduce(&:+)
    end

    # from CM to Total (summation of torque from CM to all rigid body's particles)
    def torque()
      @torque
    end


    def linear_acceleration()
      self.net_force() / @mass
    end

    def angular_acceleration()
      self.torque() / @inertia
    end

    def integrate(delta)
      @shape.move(self.linear_velocity * delta)
      @shape.rotate(self.angular_velocity * delta)
      @linear_velocity += self.linear_acceleration * delta
      @angular_velocity += self.angular_acceleration * delta
    end

  end

end