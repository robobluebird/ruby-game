class Star
  attr_reader :x, :y

  def initialize animation
    @animation = animation
    @color = Gosu::Color.new 0xff_000000
    @color.red = rand(256 - 40) + 40
    @color.green = rand(256 - 40) + 40
    @color.blue = rand(256 - 40) + 40
    @x = rand * 1280
    @y = rand * 480
  end

  def too_near? thing
    too_near = Gosu::distance(thing.x, thing.y, @x, @y) < 35
    yield if block_given? && too_near
    too_near
  end

  def draw
    img = @animation[Gosu::milliseconds / 100 % @animation.count];
    img.draw @x - img.width / 2.0, @y - img.height / 2.0, ZOrder::Stars, 1, 1, @color, :add
  end
end
