class Tower
  attr_accessor :x, :y
  
  def initialize(window, x = 0, y = 0, radius = 0)
    @window = window
    @image = Gosu::Image.new(window, "images/tower.png", false)
    @x = x
    @y = y
    @radius = radius
    @reload = 0
    place!
  end
  
  def update
    @reload -= 1 if @reload >= 1
    if reloaded? && enemy = enemy_to_kill
      fire_projectile_at(enemy)
    end
  end

  def draw(placing = false)
    argb = 
      if placing
        if can_place?
          0xff00ff00
        else
          0xffff0000
        end
      else
        0x00ffffff + (((1 - reload_percent * 0.75) * 255).to_i << 24)
      end
      
    @image.draw(x, y, 0, 1, 1, argb)
  end
  
  def reload_percent
    @reload.to_f / 100
  end
  
  def reloaded?
    @reload <= 0
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

  def place
    x_pos = ((x + 3) / 32).floor * 32
    y_pos = ((y + 3) / 32).floor * 32
    [x_pos, y_pos]
  end
  
  def place!
    self.x, self.y = place
  end  
  
  def position
    [x, y]
  end
  
  def can_place?
    @window.credits >= cost && !@window.towers.collect{ |t| t.position }.include?(place)
  end
  
  def cost
    100
  end
  
  def destroy
    @window.remove_tower(self)
  end
end