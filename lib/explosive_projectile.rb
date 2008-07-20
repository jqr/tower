class ExplosiveProjectile < Projectile
  attr_accessor :x, :y, :damage

  def initialize(window, x, y, speed, enemy)
    @image = Gosu::Image::load_tiles(window, "images/projectile.png", 25, 25, false).first
    @x = x
    @y = y
    @speed = speed
    @window = window
    @damage = 10 + rand(10)
    @size = 1
    attacking(enemy)
  end
  
  def draw
    @size += 0.04
    @image.draw(x - @size ** 2, y - @size ** 2, 0, @size, @size, color)
  end
  
  def color
    0xffff0000
  end
  
end
