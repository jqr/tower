require 'rubygems'
require 'gosu'

class Tower
  attr_accessor :x, :y
  
  def initialize(window, x, y)
    @window = window
    @image = Gosu::Image.new(window, "tower.png", false)
    @x = x
    @y = y
    @reload = 0
  end
  
  def update
    @reload -= 1
    if reloaded? && enemy = enemy_to_kill
      fire_projectile_at(enemy)
    end
  end

  def draw
    @image.draw(x, y, 0)
  end
  
  def reloaded?
    @reload < 0
  end
  
  def enemy_to_kill
    if @window.enemies.size > 0
      @window.enemies.first
    end
  end
  
  def fire_projectile_at(enemy)
    @reload = 100
    @window.projectiles << Projectile.new(@window, x, y, enemy)
  end
end

class Projectile
  attr_accessor :x, :y

  def initialize(window, x, y, enemy)
    @image = Gosu::Image::load_tiles(window, "projectile.png", 25, 25, false).first
    @x = x
    @y = y
    @enemy = enemy
  end
  
  def update
    @x += @enemy.x > x ? 1 : -1
    @y += @enemy.y > y ? 1 : -1
  end

  def draw
    @image.draw(x, y, 0)
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
  attr_accessor :towers, :projectiles, :enemies
  
  def initialize
    super(640, 480, false)
    self.caption = "Tower"
    @towers = []
    @projectiles = []
    @enemies = []
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    
    setup_basic_towers
  end

  def update
    (@towers + @projectiles + @enemies).each do |object|
      object.update
    end
  end

  def draw
    (@towers + @enemies + @projectiles).reverse.each do |object|
      object.draw
    end

    @font.draw("Prepare for craziness!", 230, 10, 0, 1.0, 1.0, 0xffffff00)
  end

  def button_down(id)
    case id
    when Gosu::Button::KbEscape
      close
    when Gosu::Button::KbSpace
      send_enemy
    end
  end
  
  def setup_basic_towers
    @towers << Tower.new(self, 100, 100)
    @towers << Tower.new(self, 100, 300)
  end
  
  def send_enemy
    @enemies << Enemy.new(self)
  end
end

window = GameWindow.new
window.show