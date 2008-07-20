require 'rubygems'
require 'gosu'

class Tower
  attr_accessor :x, :y
  
  def initialize(window, x, y, radius)
    @window = window
    @image = Gosu::Image.new(window, "images/tower.png", false)
    @x = x
    @y = y
    @radius = radius
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
      @window.enemies.detect do |enemy|
        Gosu::distance(@x, @y, enemy.x, enemy.y) < @radius
      end
    end
  end
  
  def fire_projectile_at(enemy)
    @reload = 100
    @window.add_projectile(Projectile.new(@window, x, y, 3, enemy))
  end
end

class Projectile
  attr_accessor :x, :y, :damage

  def initialize(window, x, y, speed, enemy)
    @image = Gosu::Image::load_tiles(window, "images/projectile.png", 25, 25, false).first
    @x = x
    @y = y
    @speed = speed
    @window = window
    @damage = 45 + rand(10)
    attacking(enemy)
  end
  
  def update
    move
    check_for_hit
  end

  def draw
    @image.draw(x, y, 0)
  end
  
  def attacking(enemy)
    @enemy = enemy
    
    x_distance = enemy.x - x
    y_distance = enemy.y - y
    largest = [x_distance.abs, y_distance.abs].max
    
    # FIXME: this does not properly limit speeds in two directions
    @x_delta = x_distance.to_f / largest * @speed
    @y_delta = y_distance.to_f / largest * @speed
  end
  
  def move
    attacking(@enemy)
    @x += @x_delta
    @y += @y_delta
  end
  
  def check_for_hit
    if (@x - @enemy.x) < 2 && (@y - @enemy.y) < 2
      @window.remove_projectile(self)
      @enemy.hit(self)
    end    
  end
end

class Enemy
  attr_accessor :x, :y, :distance, :health

  def initialize(window, x, y)
    @images = Gosu::Image::load_tiles(window, "images/enemy.bmp", 50, 50, false)
    @window = window
    @frame = 1
    @distance = 0
    @x = x
    @y = y
    @health = 100
  end

  def update
    exit_event
    @distance += 1
  end
    
  def draw
    frame = (@distance * 0.2) % @images.size
    @images[frame.to_i].draw(x - 15, y - 15, 0)
    # draw_health
  end
  
  def draw_health
    Gosu::Font.new(@window, Gosu::default_font_name, 15).draw(@health.to_s, x , y - 30, 0, 1.0, 1.0, 0xffffff00)
  end
  
  def y
    @distance
  end
  
  def hit(projectile)
    @health -= projectile.damage
    destroy if @health <= 0
  end

  def destroy
    @window.remove_enemy(self)
  end
  
  def exit_event
    if @distance > 480
      @window.remove_enemy(self)
      @window.increment_enemies_exited
    end
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
    @enemies_exited = 0
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

    @font.draw("Enemies: #{@enemies.size}", 540, 10, 0, 1.0, 1.0, 0xffffff00)
    @font.draw("Enemies Exited: #{@enemies_exited}", 240, 10, 0, 1.0, 1.0, 0xffffff00)
  end

  def button_down(id)
    case id
    when Gosu::Button::KbEscape
      close
    when Gosu::Button::KbSpace
      send_enemy
    when Gosu::Button::MsLeft
      place_tower(mouse_x, mouse_y)
    end
  end
  
  def place_tower(m_x, m_y)
    @towers << Tower.new(self, m_x, m_y, 150)
  end
  
  def setup_basic_towers
    @towers << Tower.new(self, 200, 100, 150)
    @towers << Tower.new(self, 100, 300, 150)
    @towers << Tower.new(self, 400, 370, 150)
    @towers << Tower.new(self, 500, 220, 150)
  end
  
  def send_enemy
    @enemies << Enemy.new(self, rand(640), 0)
  end
  
  def add_projectile(projectile)
    self.projectiles << projectile
  end
    
  def remove_enemy(enemy)
    @enemies.delete(enemy)
  end
  
  def remove_projectile(projectile)
    @projectiles.delete(projectile)
  end
  
  def increment_enemies_exited
    @enemies_exited += 1
  end
  
  def font
    @font
  end
end

window = GameWindow.new
window.show