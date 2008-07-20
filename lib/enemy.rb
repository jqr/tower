
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
    @images[frame.to_i].draw(x - 15, y - 15, 0, 1, 1, 0xffffff00 + (health.to_f / 100 * 255).to_i)
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
  
  def credit_value
    15
  end
end