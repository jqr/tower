require 'tower'
require 'projectile'
require 'explosive_projectile'
require 'enemy'
require 'round'

class GameWindow < Gosu::Window
  attr_accessor :towers, :projectiles, :enemies, :credits
  
  def initialize
    super(640, 480, false)
    init_keyboard_constants
    self.caption = "Tower"
    @towers = []
    @projectiles = []
    @enemies = []
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @enemies_exited = 0
    @cursor = Gosu::Image.new(self, "images/cursor.png", false)
    @credits = 4000
    @potential_tower = Tower.new(self)
    @rounds = []
    # setup_basic_towers
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

  def draw
    (@towers + @enemies + @projectiles).reverse.each do |object|
      object.draw
    end

    @font.draw("Round: #{@rounds.size}", 540, 10, 0, 1.0, 1.0, 0xffffff00)
    @font.draw("Moneys: #{@credits}", 10, 10, 0, 1.0, 1.0, 0xffffff00)

    if @enemies_exited > 0
      @font.draw("Enemies Exited: #{@enemies_exited}", 480, 450, 0, 1.0, 1.0, 0xffffff00)
    end
    
    if round_completed?
      text = 
        if @rounds.size > 0
          "Round Finished, press N to start next round"
        else
          "Press the N to start the flood of enemies"
        end

      @font.draw(text, 120, 240, 0, 1.0, 1.0, 0xffffff00)
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
    @enemies << Enemy.new(self, rand(590), 0)
  end
  
  def current_round
    @rounds.last
  end
    
  def place_tower(x, y)
    tower = Tower.new(self, x, y, 150)
    if tower.can_place?
      @credits = @credits - tower.cost
      @towers << tower
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
