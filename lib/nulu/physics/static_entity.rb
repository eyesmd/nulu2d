module Nulu

  class StaticEntity < Entity

    def initialize(shape, friction = 0.0)
      super(shape, INF, friction)
    end

    def velocity
      Nulu::Point.new(0, 0)
    end

    def velocity=(new_velocity)
      # cri cri
    end
  end

end