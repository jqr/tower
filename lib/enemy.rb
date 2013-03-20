class Enemy
  include Drawable

  attr_accessor :x, :y, :health, :image, :heading

  def initialize(window, x, y)
    self.image = Gosu::Image.new(window, "images/enemy.png", false)
    @window = window
    @frame = 1
    self.x = x
    self.y = y
    @health = 1000
    @previous_heading = :down
    @font = Gosu::Font.new(@window, Gosu::default_font_name, 15)
    @frame = 0
    calculate_heading
  end

  def update
    exit_event
    current_tile = @window.board.snap(x, y)
    move!
    if @window.board.snap(x, y) != current_tile
      @new_tile = true
    end
  end

  def draw
    @frame += 1
    @image.draw_rot(x + @image.width / 2, y + @image.height / 2, 0, (@frame / 10) % 2 * - 30 + 35, 0.5, 0.5)
    # draw_health
    if @window.debug
      draw_center_lines
      highlight_tile
    end
  end

  def draw_health
    @font.draw(@health.to_s, x - 8, y - 23, 0, 1, 1, 0xffffff00)
  end

  def move!
    calculate_heading if recalculate_heading?

    self.x, self.y = next_move(heading)
  end

  def recalculate_heading?
    @new_tile == true && @window.board.inside_tile?(x, y, image.width / 2)
  end

  def calculate_heading
    @new_tile = false

    cells = @window.board.surrounding_cells(board_x, board_y)

    min_distance = cells.select { |c| c.is_a?(Integer) }.min

    self.heading =
      case cells.index(min_distance)
        when 0
          :down
        when 1
          :left
        when 2
          :right
        when 3
          :up
      end
  end

  def next_move(direction)
    case direction
      when :down
        [x, y + speed]
      when :up
        [x, y - speed]
      when :left
        [x - speed, y]
      when :right
        [x + speed, y]
    end
  end

  def speed
    0.3
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
