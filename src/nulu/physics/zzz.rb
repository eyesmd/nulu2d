module Nulu

  class ZZZ

    attr_accessor :shape, :position, :orientation
    attr_accessor :mass
    attr_accessor :inertia

    def initialize(shape:, mass:, inertia:, position:Nulu::Point.new(0, 0), orientation:0)
      @shape = shape
      @position = position
      @orientation = orientation
      @mass = mass
      @inertia = inertia
      @forces = []
      @torque = 0.0

      @center_of_mass = shape.vertex.reduce(&:+) / shape.vertex.size # TODO: Temp
    end


    # Rethink this! Should it be on the Shape? Updating this is pretty lame.
    def center_of_mass
      @center_of_mass + @position
    end
    

    def add_force(force)
      @forces << force
    end


    def add_force_at(force, application_point)
      @forces << force
      @torque += force * (application_point - center_of_mass).perp(true)
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

  end

end