class Tower
  attr_accessor :x, :y
  
  def initialize(window, x = 0, y = 0, radius = 0)
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

  def draw(opacity = 1)
    @image.draw(x - @image.width / 2, y - @image.height / 2, 0, 1, 1, 0x00ffffff + ((opacity.to_f * 255).to_i << 24))
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
    @window.add_projectile(Projectile.new(@window, x - @image.width / 2, y - @image.height / 2, 3, enemy))
  end
  
  def cost
    100
  end
end