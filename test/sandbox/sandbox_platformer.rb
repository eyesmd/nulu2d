require "gosu"
require_relative "../../src/nulu"
require 'pry'
require_relative "sandbox"

class SandboxPlatformer < Sandbox
  WIDTH, HEIGHT = 1000, 600

  def initialize
    super WIDTH, HEIGHT

    @world = Nulu::World.new()

    @mc = @world.make_body(shape: Nulu::Rectangle.new(50, 50, Nulu::Point.new(WIDTH / 2.0 - 300, HEIGHT - 300)), mass: 15, friction: 1.0)
    @mc.frictionless = true

    @floors = [
      @world.make_static_body(shape: Nulu::Rectangle.new(300, 200, Nulu::Point.new(0, 0)), friction: 0.3),
      @world.make_static_body(shape: Nulu::Rectangle.new(700, 200, Nulu::Point.new(600, 100)), friction: 0.3)
    ]

    @horizontal_platforms = [
      @world.make_static_body(shape: Nulu::Rectangle.new(100, 10, Nulu::Point.new(300, 225)), friction: 0.3),
    ]

    @vertical_platforms = [
      @world.make_static_body(shape: Nulu::Rectangle.new(100, 10, Nulu::Point.new(50, 210)), friction: 0.3),
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
      @vertical_platforms.each { |platform| platform.velocity.y = 6 }
    else
      @vertical_platforms.each { |platform| platform.velocity.y = -6 }
    end
  end

  def key_down(id)
    case id
    when Gosu::KbUp
      @mc.velocity.y += 80
    end
  end

  def draw
    draw_bodies(@bodies, 0, self.height/2, 1.0)
  end

end

SandboxPlatformer.new.show()