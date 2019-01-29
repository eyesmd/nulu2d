require_relative "sandbox"

class SandboxCollision < Sandbox
  IMG_CREATE_MODE = Gosu::Image.from_text("Create Mode", 30)
  IMG_DRAG_MODE = Gosu::Image.from_text("Drag Mode", 30)
  IMG_HELP = Gosu::Image.from_text("Q - Create Mode\nW - Drag Mode", 20)

  attr_accessor :mode, :polygons
  attr_accessor :prev_mouse

  def initialize
    super 640, 480
    self.mode = :drag
    self.polygons = Array.new
    self.polygons << Nulu::Polygon.new(Nulu::Point.new(50, 50),
                                       Nulu::Point.new(200, 50),
                                       Nulu::Point.new(50, 200))
    self.polygons << Nulu::Polygon.new(Nulu::Point.new(400, 300),
                                       Nulu::Point.new(500, 300),
                                       Nulu::Point.new(500, 400),
                                       Nulu::Point.new(400, 400))
    self.prev_mouse = Nulu::Point.new(mouse_x, mouse_y)
    @current_poly = Array.new
  end

  def update
    super()
    case self.mode
      when :create
        create_update
      when :drag
        drag_update
    end

    self.prev_mouse = Nulu::Point.new(mouse_x, mouse_y)
  end

  def draw
    polygons.each do |p|
      color = p == selected_polygon ? Gosu::Color::YELLOW : Gosu::Color::RED
      draw_polygon(p, color)
    end

    (0...polygons.size).each do |i|
      (i+1...polygons.size).each do |j|
        if Nulu::Collision::colliding?(polygons[i], polygons[j])
          mtv = Nulu::Collision::mtv(polygons[i], polygons[j])
          draw_segment(Nulu::Segment.new(polygons[j].center, polygons[j].center + mtv), Gosu::Color::GREEN)
          draw_point(polygons[j].center, Gosu::Color::GREEN)
        end
      end
    end

    polygons.each do |p|

      color = p == selected_polygon ? Gosu::Color::YELLOW : Gosu::Color::RED
      draw_polygon(p, color)
    end

    IMG_HELP.draw(0, 0, 0)
    case self.mode
      when :create
        IMG_CREATE_MODE.draw(0, self.height - IMG_CREATE_MODE.height, 0)
      when :drag
        IMG_DRAG_MODE.draw(0, self.height - IMG_CREATE_MODE.height, 0)
    end

    case self.mode
      when :create
        create_draw
      when :drag
        drag_draw
    end
  end

  def key_down(id)
    case id
      when Gosu::KB_Q
        self.mode = :create
      when Gosu::KB_W
        self.mode = :drag
        current_poly.clear
    end

    case self.mode
      when :create
        create_button_down(id)
      when :drag
        drag_button_down(id)
    end
  end

  def key_up(id)
    case self.mode
      when :create
        create_button_up(id)
      when :drag
        drag_button_up(id)
    end
  end

  def needs_cursor?
    true
  end


  attr_accessor :current_poly
  def create_update
    # code
  end

  def create_draw
    unless current_poly.empty?
      (0...current_poly.size-1).each do |i|
        draw_segment(Nulu::Segment.new(current_poly[i], current_poly[i+1]))
      end
      draw_segment(Nulu::Segment.new(current_poly.last, Nulu::Point.new(mouse_x, mouse_y)))
    end
  end

  def create_button_down(id)
    mouse = Nulu::Point.new(mouse_x, mouse_y)
    if id == Gosu::MS_LEFT
      if self.current_poly.empty?
        self.current_poly << mouse
      elsif self.current_poly[0].distance(mouse) < 10
        @polygons << Nulu::Polygon.new(*@current_poly)
        @current_poly.clear
      else
        self.current_poly << mouse
      end
    end
  end

  def create_button_up(id)
    # code
  end

  attr_accessor :selected_polygon, :drag_start
  def drag_update
    if drag_start
      mouse = Nulu::Point.new(mouse_x, mouse_y)
      selected_polygon.move(mouse - prev_mouse)
    end
  end

  def drag_draw
    # code
  end

  def drag_button_down(id)
    mouse = Nulu::Point.new(mouse_x, mouse_y)
    if id == Gosu::MS_LEFT
      polygons.each do |p|
        if Nulu::Collision.containing?(p, mouse)
          self.selected_polygon = p
          self.drag_start = mouse
          return
        end
      end

      self.selected_polygon = nil
    end
  end

  def drag_button_up(id)
    if id == Gosu::MS_LEFT
      self.drag_start = nil
    end
  end
end

SandboxCollision.new.show