class ExplosiveProjectile < Projectile
  attr_accessor :x, :y, :damage

  def initialize(window, x, y, speed, enemy)
    @size = 1
    super
    @damage = 10 + rand(120)
  end
  
  def draw
    @size += 0.04
    @image.draw(x, y, 0, @size, @size, color)
  end
    
  def width
    @size * @image.width
  end

  def height
    @size * @image.height
  end
  
  def collision_radius
    (@image.width * @size) / 2
  end
  
  def color
    0xffff0000
  end
  
end
