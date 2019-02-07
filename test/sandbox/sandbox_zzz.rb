require_relative "sandbox"

class SandboxZZZ < Sandbox

  def initialize
    super()
    @dragging = false
    @drag_base = nil
    @force = nil
    @zzz = Nulu::ZZZ.new(
      shape: Nulu::Polygon.new(Nulu::Point.new(400, 300),
                               Nulu::Point.new(500, 300),
                               Nulu::Point.new(500, 400),
                               Nulu::Point.new(400, 400)),
      mass: 10.0,
      inertia: 10000.0)
    #update_text()
  end

  def update
    super()
    @force = Nulu::Point.new(mouse_x, mouse_y) - @drag_base if @dragging
    @zzz.integrate(@delta)
    update_text()
  end

  def key_down(id)
    if id == Gosu::MS_LEFT
      @dragging = true
      @drag_base = Nulu::Point.new(mouse_x, mouse_y)
    end

    if id == Gosu::KB_R
      @zzz.clear_forces()
      #update_text()
    end
  end

  def key_up(id)
    if id == Gosu::MS_LEFT
      @dragging = false
      @zzz.clear_forces()
      @zzz.add_force_at(@force, Nulu::Point.new(mouse_x, mouse_y))
      #update_text()
    end
  end

  def draw
    self.draw_polygon(@zzz.shape)
    self.draw_arrow(Nulu::Segment.new(@drag_base, @drag_base + @force)) if @dragging
    @text_linear_acceleration.draw(10, self.height - 30 * 2, 0)
    @text_angular_acceleration.draw(10, self.height - 30, 0)
    @text_linear_velocity.draw(10, self.height - 30 * 4, 0)
    @text_angular_velocity.draw(10, self.height - 30 * 3, 0)
  end

  def update_text
    @text_linear_acceleration = Gosu::Image.from_text("Linear acceleration = (#{@zzz.linear_acceleration.x}, #{@zzz.linear_acceleration.y})", 30)
    @text_angular_acceleration = Gosu::Image.from_text("Angular acceleration = #{@zzz.angular_acceleration}", 30)
    @text_linear_velocity = Gosu::Image.from_text("Linear velocity = (#{@zzz.linear_velocity.x}, #{@zzz.linear_velocity.y})", 30)
    @text_angular_velocity = Gosu::Image.from_text("Angular velocity = #{@zzz.angular_velocity}", 30)
  end

end

SandboxZZZ.new.show