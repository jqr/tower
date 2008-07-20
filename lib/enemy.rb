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
    move!
  end
    
  def draw
    frame = (@distance * 0.2) % @images.size
    @images[frame.to_i].draw(x, y, 0, 1, 1, 0xffffff00 + (health.to_f / 100 * 255).to_i)
    # draw_health
  end
  
  def move!
    self.x, self.y = next_move(direction?)
    @x, @y = x, y
  end
  
  def direction?    
    case true
      when can_move_down?
        :down
      when can_move_left?
        :left
      when can_move_right?
        :right
      when can_move_up?
        :up
    end
  end  
  
  def can_move_down?
    true
  end
  
  def can_move_up?
  end
  
  def can_move_left?
  end
  
  def can_move_right?
  end
  
  def next_move(direction)
    case direction
      when :down
        [@x, @y + speed]
      when :up
        [@x, @y - speed]
      when :left
        [@x - speed, @y]
      when :right
        [@x - speed, @y]
    end
  end
  
  def speed
    0.75
  end
  
  def position
    [x,y]
  end
  
  def draw_health
    Gosu::Font.new(@window, Gosu::default_font_name, 15).draw(@health.to_s, x , y - 30, 0, 1.0, 1.0, 0xffffff00)
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