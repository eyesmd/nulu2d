module Nulu

  class Rectangle < Nulu::Polygon

  	def initialize(width, height, initial_pos = Nulu::Point.new(0, 0))
      initial_x = initial_pos.x
      initial_y = initial_pos.y
      super(Nulu::Point.new(initial_x, initial_y),
          Nulu::Point.new(initial_x + width, initial_y),
          Nulu::Point.new(initial_x + width, initial_y + height),
          Nulu::Point.new(initial_x, initial_y + height))
    end

  end
  
end