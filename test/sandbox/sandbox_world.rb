require "gosu"
require_relative "../../src/nulu"
require 'pry'
require_relative "sandbox"

class SandboxWorld < Sandbox
  WIDTH, HEIGHT = 1000, 600
  CAMERA_ZOOM = 1.0

  def initialize
    super WIDTH, HEIGHT

    @world = Nulu::World.new()
    @mc = @world.make_body(Nulu::Rectangle.new(100, 100, Nulu::Point.new(WIDTH / 2.0 - 300, HEIGHT - 300)), 15, 0.0)
    @floor = @world.make_static_body(Nulu::Rectangle.new(1500, 200, Nulu::Point.new(-WIDTH / 2.0, HEIGHT - 650)), 0.3)
    @solid_box = @world.make_body(Nulu::Rectangle.new(100, 150, Nulu::Point.new(WIDTH / 2.0 - 100, HEIGHT - 300)), 15, 0.0, :box)
    @pass_box = @world.make_body(Nulu::Rectangle.new(10, 250, Nulu::Point.new(WIDTH / 2.0 + 200, HEIGHT - 300)), 15, 0.0, :wall)

    @world.disable_collision_between(:box, :wall)

    @objects = [@mc, @floor, @solid_box, @pass_box]
  end

  def update()
    super()
    read_keyboard()
    @world.update(@delta)
  end

  def read_keyboard()
    @active_keys.each do |key_id|
      case key_id
      when Gosu::KbRight
        @mc.velocity.x += 20
      when Gosu::KbLeft
        @mc.velocity.x -= 20
      when Gosu::KbUp
        @mc.mass += 1.0
        puts(@mc.mass)
      when Gosu::KbDown
        @mc.mass -= 1.0
        @mc.mass = 0.0 if @mc.mass < 0.0
        puts(@mc.mass)
      when Gosu::KbZ
        @mc.frictionless = !@mc.frictionless
        puts(@mc.friction)
      when Gosu::KbX
        @mc.move_x(10)
      end
    end
  end

  def draw
    draw_bodies(@objects, 0, self.height/2, 1.0)
  end

end

SandboxWorld.new.show()