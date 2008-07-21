class Projectile
  attr_accessor :x, :y, :damage

  def initialize(window, x, y, speed, enemy)
    @image = Gosu::Image::load_tiles(window, "images/projectile.png", 25, 25, false).first
    @x = x
    @y = y
    @speed = speed
    @window = window
    @damage = rand(10)
    attacking(enemy)
    @size = 0.5
  end
  
  def update
    move
    check_for_hit
  end

  def draw
    @image.draw(x, y, 0, @size, @size, color)
  end
  
  def color
    0xffffffff
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
    if Gosu::distance(@x, @y, @enemy.x, @enemy.y) < collision_size
      destroy
      @enemy.hit(self)
    end    
  end
  
  def collision_size
    @image.width
  end

  def destroy
    @window.remove_projectile(self)
  end
end
