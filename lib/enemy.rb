class Enemy
  include Drawable
  
  attr_accessor :x, :y, :distance, :health

  def initialize(window, x, y)
    @image = Gosu::Image.new(window, "images/enemy.png", false)
    @window = window
    @frame = 1
    @distance = 0
    @x = x
    @y = y
    @health = 100
    @previous_heading = :down
    @font = Gosu::Font.new(@window, Gosu::default_font_name, 15)
    @frame = 0
  end

  def update
    exit_event
    @distance += 1
    move!
  end
    
  def draw
    @frame += 1
    @image.draw_rot(x + @image.width / 2, y + @image.height / 2, 0, (@frame / 10) % 2 * - 30 + 35, 0.5, 0.5)
    # draw_health
    draw_center_lines
    
  end
  
  def draw_health
    @font.draw(@health.to_s, x - 8, y - 23, 0, 1, 1, 0xffffff00)
  end
  
  def center_x
    x + @image.width / 2
  end  

  def center_y
    y + @image.height / 2
  end
  
  def move!
    self.x, self.y = next_move(heading)
  end
  
  def heading
    cells = @window.board.surrounding_cells(board_x, board_y)
    min_distance = cells.select { |c| c.is_a?(Integer) }.min
    case cells.index(min_distance)
      when 0:
        :down
      when 1:
        :left
      when 2: 
        :right
      when 3:
        :down
    end
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
        [@x + speed, @y]
    end
  end
  
  def speed
    0.75
  end
  
  def position
    [x, y]
  end
  
  def hit(projectile)
    @health -= projectile.damage
    destroy if @health <= 0
  end

  def destroy
    @window.remove_enemy(self)
  end
  
  def exit_event
    if y > @window.height
      @window.remove_enemy(self)
      @window.increment_enemies_exited
    end
  end
  
  def credit_value
    15
  end
end