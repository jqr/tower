require 'rubygems'
require 'gosu'

class Tower
  attr_accessor :x, :y
  
  def initialize(window)
    @image = Gosu::Image.new(window, "tower.png", false)
  end
  
  def update
  end

  def draw
  end
end

class Projectile
  attr_accessor :x, :y

  def initialize(window)
    @image = Gosu::Image.new(window, "projectile.png", false)
  end
  
  def update
  end

  def draw
  end
end

class Enemy
  attr_accessor :x, :y, :distance

  def initialize(window)
    @images = Gosu::Image::load_tiles(window, "enemy.bmp", 50, 50, false)
    @frame = 1
    @distance = 0
    @x = @y = 0
  end

  def update
    @distance += 1
  end
    
  def draw
    frame = (@distance * 0.2) % @images.size
    @images[frame.to_i].draw(x, y, 0)
  end
  
  def y
    @distance
  end
  
end

class GameWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    self.caption = "Tower"
    @towers = []
    @projectiles = []
    @enemies = []
  end

  def update
    (@towers + @projectiles + @enemies).each do |object|
      object.update
    end
  end

  def draw
    (@towers + @projectiles + @enemies).each do |object|
      object.draw
    end
  end

  def button_down(id)
    case id
    when Gosu::Button::KbEscape
      close
    when Gosu::Button::KbSpace
      send_enemy
    end
  end
  
  def send_enemy
    @enemies << Enemy.new(self)
  end
end

window = GameWindow.new
window.show