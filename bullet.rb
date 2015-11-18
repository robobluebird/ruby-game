require 'gosu'

class Bullet
  def initialize x, y, angle, size = 4
    @x = x
    @y = y
    @angle = angle
    @speed = 20
    @size = size
    @color = Gosu::Color.new 0xff000000
    @color.red = rand(256 - 40) + 40
    @color.green = rand(256 - 40) + 40
    @color.blue = rand(256 - 40) + 40
  end

  def visible? x_range, y_range
    x_range.cover?(@x) && y_range.cover?(@y)
  end

  def cx
    @x - (@size / 2)
  end

  def cy
    @y - (@size / 2)
  end

  def move
    @x += Gosu::offset_x @angle, @speed
    @y += Gosu::offset_y @angle, @speed
  end

  def draw
    Gosu.draw_rect cx, cy, @size, @size, @color, ZOrder::Player - 1
  end
end
