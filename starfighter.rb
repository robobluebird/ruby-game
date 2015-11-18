require 'gosu'

class Starfighter
  attr_reader :x, :y

  def initialize
    @image = Gosu::Image.new "assets/starfighter.bmp"
    @x = 0.0
    @y = 0.0
    @vx = 0.0
    @vy = 0.0
    @wx = 640
    @wy = 480
    @backoff = 0.95
    @angle = 0.0
    @speed = 0.5
    @score = 0
    @slide_time = 0
  end

  def warp nx, ny
    @x, @y = nx, ny
  end

  def turn_left
    @angle -= 4.5
  end

  def turn_right
    @angle += 4.5
  end

  def accelerate
    @vx += Gosu::offset_x @angle, @speed
    @vy += Gosu::offset_y @angle, @speed
  end

  def slide
    if not_sliding
      @slide_time = 50
      @vx += Gosu::offset_x @angle, 10.0
      @vy += Gosu::offset_y @angle, 10.0
    else
      less_slide
    end
  end

  def less_slide
    @slide_time -= 1 if @slide_time > 0
  end

  def not_sliding
    @slide_time == 0
  end

  def trundle direction
    if not_sliding
      @angle = direction_to_angle direction
      @vx = Gosu::offset_x @angle, 2.5
      @vy = Gosu::offset_y @angle, 2.5
    else
      less_slide
    end
  end

  def direction_to_angle direction
    case direction
    when 0
      0.0
    when 1
      90.0
    when 2
      180.0
    when 3
      270.0
    end
  end

  def move
    @x += @vx
    @y += @vy

    @vx *= @backoff
    @vy *= @backoff
  end

  def fire
    Bullet.new @x, @y, @angle
  end

  def upscore
    @score += 1
  end

  def draw
    @image.draw_rot x, y, ZOrder::Player, @angle
  end
end
