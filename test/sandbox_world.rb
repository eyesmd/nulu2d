require "gosu"
require_relative "../lib/nulu"
require 'pry'

class Sandbox < Gosu::Window
  WIDTH, HEIGHT = 1000, 600
  CAMERA_ZOOM = 1.0

  def initialize
    super WIDTH, HEIGHT
    self.caption = "Sandbox"

    @elapsed = 0
    @active_keys = []

    @world = Nulu::World.new()
    @mc = @world.make_entity(Nulu::Rectangle.new(100, 100, Nulu::Point.new(WIDTH / 2.0 - 200, HEIGHT - 300)), 15)
    @floor = @world.make_static_entity(Nulu::Rectangle.new(1500, 200, Nulu::Point.new(WIDTH / 2.0, HEIGHT - 650)), 0.3)

    @objects = []
    @objects << @mc
    @objects << @floor
    @objects << @world.make_entity(Nulu::Rectangle.new(100, 150, Nulu::Point.new(WIDTH / 2.0, HEIGHT - 300)), 15)
  end

  # LOOP
  # -----

  def update()
    delta = ((Gosu.milliseconds() || 0) - @elapsed) / 100.0
    @elapsed = Gosu.milliseconds() || 0
    read_keyboard()
    @world.update(delta)
  end


  # CONTROLLING
  # +++++++++++

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

  def button_down(id)
    @active_keys << id
    case id
      when Gosu::KB_ESCAPE
        close()
    end
  end

  def button_up(id)
    @active_keys.delete(id)
  end


  # DRAWING
  # +++++++

  def draw
    Gosu.scale(CAMERA_ZOOM, -CAMERA_ZOOM, WIDTH/2, HEIGHT/2 - 100) do
      @objects.each do |entity|
        draw_polygon(entity.shape, Gosu::Color::WHITE)
        draw_segment(Nulu::Segment.new(entity.center, entity.center + entity.velocity), Gosu::Color::FUCHSIA)
        draw_segment(Nulu::Segment.new(entity.center, entity.center + entity.normal), Gosu::Color::YELLOW)
      end
    end
  end

  def draw_segment(segment, color=Gosu::Color::WHITE)
    Gosu::draw_line(segment.a.x, segment.a.y, color,
                    segment.b.x, segment.b.y, color, 100)
  end

  def draw_polygon(polygon, color=Gosu::Color::WHITE)
    polygon.segments.each{|s| draw_segment(s, color)}
  end

end

Sandbox.new.show()