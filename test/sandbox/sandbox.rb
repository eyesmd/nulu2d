require "gosu"
require 'pry'
require_relative "../../src/nulu"

class Sandbox < Gosu::Window

  attr_accessor :delta, :delta_ms
  attr_accessor :active_keys

  # Initialization
  # ++++++++++++++

  def initialize(width = 640, height = 480, caption = "Sandbox")
    super width, height
    self.caption = caption
    @delta = 0.0
    @elapsed = 0.0
    @active_keys = []
  end


  # Update
  # +++++++

  def update()
    @delta = ((Gosu.milliseconds() || 0) - @elapsed) / 100.0
    @elapsed = Gosu.milliseconds() || 0
  end


  # Keyboard
  # +++++++

  def button_down(id)
    @button_down
    @active_keys << id
    case id
      when Gosu::KB_ESCAPE
        close()
    end
    key_down(id)
  end

  def key_down(id)
    # To override
  end

  def button_up(id)
    @active_keys.delete(id)
    key_up(id)
  end

  def key_up(id)
    # To override
  end


  # Drawing
  # +++++++

  def draw_bodies(bodies, offset_x = 0, offset_y = 0, zoom = 1.0)
    Gosu.scale(zoom, -zoom, width/2, height/2) do
      Gosu.translate(offset_x, offset_y) do
        bodies.each do |body|
          draw_polygon(body.shape, Gosu::Color::WHITE)
          draw_segment(Nulu::Segment.new(body.center, body.center + body.velocity), Gosu::Color::FUCHSIA)
          body.normals.each do |normal|
            draw_segment(Nulu::Segment.new(body.center, body.center + normal), Gosu::Color::YELLOW)
          end
        end
      end
    end
  end

  def draw_circle(center, radius, color=Gosu::Color::WHITE)
    stp = radius/5.0
    [-1,1].each do |sign|
      (-radius...radius).step(stp) do |x|
        ax = center.x + x
        ay = center.y + sign * Math.sqrt(radius**2 - x**2)
        bx = center.x + x + stp
        by = center.y + sign * Math.sqrt(radius**2 - ((x + stp).round)**2)
        Gosu::draw_line(ax, ay, color, bx, by, color, 100)
      end
    end
  end

  def draw_point(point, color=Gosu::Color::WHITE)
    draw_circle(point, 3, color)
  end

  def draw_segment(segment, color=Gosu::Color::WHITE)
    Gosu::draw_line(segment.a.x, segment.a.y, color,
                    segment.b.x, segment.b.y, color, 100)
  end

  def draw_polygon(polygon, color=Gosu::Color::WHITE)
    polygon.segments.each{|s| draw_segment(s, color)}
  end

end