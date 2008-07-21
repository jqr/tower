require 'tower'
require 'projectile'
require 'explosive_projectile'
require 'enemy'
require 'round'

class GameWindow < Gosu::Window
  GRID_WIDTH = 32
  GRID_HEIGHT = 32
  GRID_COLOR = 0x1100ff00
  
  attr_accessor :towers, :projectiles, :enemies, :credits
  
  def initialize(rows, columns)
    super(rows * GRID_WIDTH, columns * GRID_HEIGHT, false)
    init_keyboard_constants
    self.caption = "Tower"

    @grid_rows = rows
    @grid_columns = columns
    @grid = Array.new(columns).collect { |a| Array.new(rows) }
    
    @towers = []
    @projectiles = []
    @enemies = []
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @enemies_exited = 0
    @cursor = Gosu::Image.new(self, "images/cursor.png", false)
    @credits = 4000
    @potential_tower = Tower.new(self)
    @rounds = []
    
    recalculate_grid
  end

  def init_keyboard_constants
    ('a'..'z').each do |letter|
      eval "Gosu::Kb#{letter.upcase} = #{self.char_to_button_id(letter)}"
    end
  end
  
  def update
    (@towers + @projectiles + @enemies).each do |object|
      object.update
    end
    current_round.send_enemy if current_round && current_round.send_enemy_now?
  end
  
  def recalculate_grid
    @grid.each_with_index do |column, x|
      column.each_with_index do |cell, y|
        @grid[x][y] = nil if @grid[x][y].is_a?(Integer)
      end
    end
    
    @grid_columns.times do |x|
      @grid[x][@grid_rows - 1] ||= 1
    end
    
    30.times do
      @grid.each_with_index do |column, x|
        column.each_with_index do |cell, y|
          unless cell.is_a?(Tower)
            distances = surrounding_cells(x, y).select do |value|
              value.is_a?(Integer)
            end
          
            distances += [cell]
            distances.compact!
            
            if distances.size > 0
              min_distance = distances.min
              if @grid[x][y] == nil || min_distance + 1 < @grid[x][y]
                @grid[x][y] = min_distance + 1
              end
            end
          end
        end
      end
    end
  end
  
  def surrounding_cells(x, y)
    distances = []
    if y + 1 < @grid_rows
      distances << @grid[x][y + 1]
    end

    if x > 0
      distances << @grid[x - 1][y]
    end

    if x + 1 < @grid_columns
      distances << @grid[x + 1][y]
    end

    if y > 0
      distances << @grid[x][y - 1]
    end
    
    distances
  end
  
  def draw_grid
    @grid_columns.times do |distance|
      draw_line(GRID_WIDTH * distance, 0, GRID_COLOR, GRID_WIDTH * distance, height, GRID_COLOR)
    end
    @grid_rows.times do |distance|
      draw_line(0, GRID_HEIGHT * distance, GRID_COLOR, width, GRID_HEIGHT * distance, GRID_COLOR)
    end
    
    @grid.each_with_index do |column, x|
      column.each_with_index do |cell, y|
        unless cell.is_a?(Tower)
          @font.draw(cell, x * GRID_WIDTH + 9, y * GRID_HEIGHT + 9, 0, 1.0, 1.0, GRID_COLOR)
        end
      end
    end
  end

  def draw
    draw_grid
    
    (@towers + @enemies + @projectiles).reverse.each do |object|
      object.draw
    end

    @font.draw("Round: #{@rounds.size}", width - 85, 10, 0, 1.0, 1.0, 0xffffff00)
    @font.draw("Moneys: #{@credits}", 10, 10, 0, 1.0, 1.0, 0xffffff00)

    if @enemies_exited > 0
      @font.draw("Enemies Exited: #{@enemies_exited}", width - 150, height - 30, 0, 1.0, 1.0, 0xffffff00)
    end
    
    if round_completed?
      text = 
        if @rounds.size > 0
          "Round Finished, press N"
        else
          "Press the N key to start"
        end

      @font.draw(text, width / 2 - 80, height / 2, 0, 1.0, 1.0, 0xffffff00)
    end
    
    if @potential_tower
      @potential_tower.x = mouse_x
      @potential_tower.y = mouse_y
      @potential_tower.place!
      @potential_tower.draw(true)
    end
    @cursor.draw(mouse_x, mouse_y, 0)
  end

  def button_down(id)
    case id
    when Gosu::Button::KbEscape
      close
    when Gosu::KbN
      start_round if round_completed?
    when Gosu::Button::MsLeft
      place_tower(mouse_x, mouse_y)
    end
  end
  
  def start_round
    @rounds << Round.new(self, @rounds.size + 1) do
      send_enemy
    end
    current_round.start!
  end
  
  def send_enemy
    @enemies << Enemy.new(self, rand((@grid_columns - 2) * GRID_WIDTH) + GRID_WIDTH, 0)
  end
  
  def current_round
    @rounds.last
  end
    
  def place_tower(x, y)
    tower = Tower.new(self, x, y, 150)
    if tower.can_place?
      @credits = @credits - tower.cost
      @towers << tower
      @grid[tower.grid_x][tower.grid_y] = tower
      recalculate_grid
    end
  end
  
  def tower_positions
    @towers.collect do |tower|
      tower.position
    end
  end
  
  def all_enemies_sent?
    current_round && current_round.all_enemies_sent? || !current_round
  end
  
  def round_completed?
    all_enemies_sent? && @enemies.size == 0
  end
    
  def add_projectile(projectile)
    self.projectiles << projectile
  end
    
  def remove_enemy(enemy)
    if @enemies.delete(enemy)
      @credits += enemy.credit_value
    end
  end
  
  def remove_projectile(projectile)
    @projectiles.delete(projectile)
  end

  def remove_tower(tower)
    @towers.delete(tower)
  end
  
  def increment_enemies_exited
    @enemies_exited += 1
  end
  
  def font
    @font
  end

  def wall_time
    Gosu::milliseconds
  end
end
