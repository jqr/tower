class ExplosiveProjectile < Projectile
  attr_accessor :x, :y, :damage

  def initialize(window, x, y, speed, enemy)
    super
    @damage = 10 + rand(10)
    @size = 1
  end
  
  def draw
    @size += 0.04
    @image.draw(x - @size ** 2, y - @size ** 2, 0, @size, @size, color)
  end
  
  def color
    0xffff0000
  end
  
end
