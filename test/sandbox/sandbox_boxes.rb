require_relative "sandbox"

class SandboxBoxes < Sandbox
  WIDTH, HEIGHT = 1000, 600
  STAGE_FRICTION = 0.3
  BOX_FRICTION = 0.3

  def initialize
    super WIDTH, HEIGHT

    @world = Nulu::World.new()

    @mc = @world.make_body(shape: Nulu::Rectangle.new(50, 50, Nulu::Point.new(WIDTH / 2.0 - 200, 200)), mass: 15, friction: 1.0)
    @mc.frictionless = true

    @floors = [
      @world.make_static_body(shape: Nulu::Rectangle.new(500, 200, Nulu::Point.new(250, 0)), friction: STAGE_FRICTION)
    ]

    @boxes = [
      # STACKED
      @world.make_body(shape: Nulu::Rectangle.new(40, 40, Nulu::Point.new(400, 400)), friction: BOX_FRICTION),
      @world.make_body(shape: Nulu::Rectangle.new(40, 40, Nulu::Point.new(400, 450)), friction: BOX_FRICTION),

      # HOUSE OF CARDS
      # First Row
      #@world.make_body(shape: Nulu::Rectangle.new(40, 40, Nulu::Point.new(500, 400)), friction: BOX_FRICTION),
      #@world.make_body(shape: Nulu::Rectangle.new(40, 40, Nulu::Point.new(550, 400)), friction: BOX_FRICTION),
      #@world.make_body(shape: Nulu::Rectangle.new(40, 40, Nulu::Point.new(450, 400)), friction: BOX_FRICTION),
      # Second Row
      #@world.make_body(shape: Nulu::Rectangle.new(40, 40, Nulu::Point.new(525, 450)), friction: BOX_FRICTION),
      #@world.make_body(shape: Nulu::Rectangle.new(40, 40, Nulu::Point.new(475, 450)), friction: BOX_FRICTION),
    ]

    @bodies = @floors + @boxes + [@mc]
  end

  def update()
    super()
    mc_update()
    @world.update(@delta)
  end

  def mc_update()
    if @active_keys.include?(Gosu::KbRight) && !@active_keys.include?(Gosu::KbLeft)
      @mc.velocity.x += 15
      @mc.velocity.x = 30 if @mc.velocity.x > 30
    elsif !@active_keys.include?(Gosu::KbRight) && @active_keys.include?(Gosu::KbLeft)
      @mc.velocity.x -= 15
      @mc.velocity.x = -30 if @mc.velocity.x < -30
    else
      @mc.velocity.x = 0
    end
  end

  def key_down(id)
    case id
    when Gosu::KbUp
      @mc.velocity.y += 80
    end
  end

  def draw
    draw_bodies(@bodies, 0, 0, 1.0)
  end
end

SandboxBoxes.new.show()