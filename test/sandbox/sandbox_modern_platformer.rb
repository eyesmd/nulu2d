require "gosu"
require_relative "../../src/nulu"
require 'pry'
require_relative "sandbox"

class SandboxModernPlatformer < Sandbox
  WIDTH, HEIGHT = 1000, 600
  STAGE_FRICTION = 0.3

  def initialize
    super WIDTH, HEIGHT

    @world = Nulu::World.new()

    @mc = @world.make_body(shape: Nulu::Rectangle.new(50, 50, Nulu::Point.new(WIDTH / 2.0 - 275, 200)), mass: 15, friction: 1.0)

    @floors = [
      # Floor
      @world.make_static_body(shape: Nulu::Rectangle.new(900, 200, Nulu::Point.new(-600, 0)), friction: STAGE_FRICTION),
      # Roof
      @world.make_static_body(shape: Nulu::Rectangle.new(550, 200, Nulu::Point.new(-600, 400)), friction: STAGE_FRICTION),
      # Regular Ramp
      @world.make_static_body(
      shape: Nulu::Polygon.new(Nulu::Point.new(200, 200),
                               Nulu::Point.new(0, 200),
                               Nulu::Point.new(0, 270)),
      friction: STAGE_FRICTION),
      @world.make_static_body(
      shape: Nulu::Polygon.new(Nulu::Point.new(-100, 200),
                               Nulu::Point.new(-100, 270),
                               Nulu::Point.new(0, 270),
                               Nulu::Point.new(0, 200)),
      friction: STAGE_FRICTION),
      @world.make_static_body(
      shape: Nulu::Polygon.new(Nulu::Point.new(-300, 200),
                               Nulu::Point.new(-100, 200),
                               Nulu::Point.new(-100, 270)),
      friction: STAGE_FRICTION),
      # Extreme Ramp
      @world.make_static_body(
      shape: Nulu::Polygon.new(Nulu::Point.new(-300, 200),
                              Nulu::Point.new(-400, 200),
                              Nulu::Point.new(-400, 270)),
      friction: STAGE_FRICTION),
      @world.make_static_body(
      shape: Nulu::Polygon.new(Nulu::Point.new(-400, 200),
                               Nulu::Point.new(-400, 270),
                               Nulu::Point.new(-500, 360),
                               Nulu::Point.new(-500, 200)),
      friction: STAGE_FRICTION)
    ]

    @horizontal_platforms = [
      @world.make_static_body(shape: Nulu::Rectangle.new(100, 10, Nulu::Point.new(300, 225)), friction: STAGE_FRICTION),
    ]

    @vertical_platforms = [
      @world.make_static_body(shape: Nulu::Rectangle.new(100, 10, Nulu::Point.new(150, 300)), friction: STAGE_FRICTION),
    ]

    @bodies = [@mc] + @floors + @horizontal_platforms + @vertical_platforms
  end

  def update()
    super()
    mc_update()
    vertical_platforms_update()
    horizontal_platforms_update()
    @world.update(@delta)
  end

  def mc_update()
    if @mc.floor_normal.y > 0.3
      if @active_keys.include?(Gosu::KbUp)
        @mc.velocity.y += 80
      elsif @active_keys.include?(Gosu::KbRight) && !@active_keys.include?(Gosu::KbLeft)
        @mc.velocity.x += 15
        @mc.frictionless = true
        @mc.velocity = @mc.velocity.trim(30)
      elsif !@active_keys.include?(Gosu::KbRight) && @active_keys.include?(Gosu::KbLeft)
        @mc.velocity.x -= 15
        @mc.frictionless = true
        @mc.velocity = @mc.velocity.trim(30)
      else
        @mc.frictionless = false
      end
    end
  end

  HORIZONTAL_CYCLE_LENGTH = 6 * 1000.0
  def horizontal_platforms_update()
    progress = (@elapsed % HORIZONTAL_CYCLE_LENGTH) / HORIZONTAL_CYCLE_LENGTH
    if progress <= 0.5
      @horizontal_platforms.each { |platform| platform.velocity.x = 6 }
    else
      @horizontal_platforms.each { |platform| platform.velocity.x = -6 }
    end
  end

  VERTICAL_CYCLE_LENGTH = 6 * 1000.0
  def vertical_platforms_update()
    progress = (@elapsed % VERTICAL_CYCLE_LENGTH) / VERTICAL_CYCLE_LENGTH
    if progress <= 0.5
      @vertical_platforms.each { |platform| platform.velocity.y = 4 }
    else
      @vertical_platforms.each { |platform| platform.velocity.y = -4 }
    end
  end

  def draw
    draw_bodies(@bodies, 500, 0, 1.0)
  end

end

SandboxModernPlatformer.new.show()