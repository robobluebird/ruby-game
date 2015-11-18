require 'gosu'
require './starfighter'
require './star'
require './z_order'
require './bullet'

class GameWindow < Gosu::Window
  def initialize
    @width = 640
    @height = 480
    @background = Gosu::Image.new "assets/space.png", tileable: true
    @starfighter = Starfighter.new
    @starfighter.warp half_width, half_height
    @bullets = []
    @bp = [0, 0, 0, 0] # number of frames each direction has been held for
    @star_animation = Gosu::Image::load_tiles "assets/star.png", 25, 25
    @stars = [].tap {|a| 100.times { a.push Star.new @star_animation }}
    super @width, @height
  end

  def update
    if Gosu::button_down? Gosu::KbUp
      @bp[0] += 1
    else
      @bp[0] = 0 if @bp[0] > 0
    end

    if Gosu::button_down? Gosu::KbRight
      @bp[1] += 1
    else
      @bp[1] = 0 if @bp[1] > 0
    end

    if Gosu::button_down? Gosu::KbDown
      @bp[2] += 1
    else
      @bp[2] = 0 if @bp[2] > 0
    end

    if Gosu::button_down? Gosu::KbLeft
      @bp[3] += 1
    else
      @bp[3] = 0 if @bp[3] > 0
    end

    if @bp.any? {|el| el > 0 }
      # return the index with the smallest positive integer
      # given that we are counting the number of frames that a movement dir has been pressed,
      # it follows that the smallest non-zero number is pressed most recently
      # go this way because all new dir presses override the old ones
      @starfighter.trundle @bp.index @bp.select{|key| !key.zero? }.min
    end

    if Gosu::button_down? Gosu::KbSpace
      @starfighter.slide
    end

    if Gosu::button_down? Gosu::KbF
      @bullets << @starfighter.fire
    end

    @bullets.map &:move
    @starfighter.move

    @stars.reject! do |star|
      star.too_near?(@starfighter) { @starfighter.upscore }
    end

    @bullets.reject! do |bullet|
      !bullet.visible? player_relative_width_range, player_relative_height_range
    end
  end

  def player_relative_width_range
    (@starfighter.x - half_width)..(@starfighter.x + half_width)
  end

  def player_relative_height_range
    (@starfighter.y - half_height)..(@starfighter.y + half_height)
  end

  def visible_width
    -tx..tx
  end

  def visible_height
    -ty..ty
  end

  def screen_width_range
    -half_width..half_width
  end

  def screen_height_range
    -half_height..half_height
  end

  def half_width
    @width / 2
  end

  def half_height
    @height / 2
  end

  def translated_x_for_gosu
    half_width - @starfighter.x
  end

  def translated_y_for_gosu
    half_height - @starfighter.y
  end

  def button_down id
    close if id == Gosu::KbEscape
  end

  def draw
    Gosu.translate translated_x_for_gosu, translated_y_for_gosu do
      @background.draw 0, 0, ZOrder::Background

      @starfighter.draw

      # only draw the stars in our current field of view
      @stars.select do |star|
        player_relative_width_range.cover?(star.x) &&
          player_relative_height_range.cover?(star.y)
      end.each &:draw

      @bullets.each &:draw
    end
  end
end
