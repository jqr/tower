require 'tower'
require 'projectile'
require 'enemy'
require 'round'

class GameWindow < Gosu::Window
  attr_accessor :towers, :projectiles, :enemies
  
  def initialize
    super(640, 480, false)
    self.caption = "Tower"
    @towers = []
    @projectiles = []
    @enemies = []
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @enemies_exited = 0
    @cursor = Gosu::Image.new(self, "images/cursor.png", false)
    @credits = 50000
    @potential_tower = Tower.new(self)
    @enemies_sent_this_round = 0
    @rounds = []
    @send_enemy_counter = 0
    # setup_basic_towers
  end

  def update
    (@towers + @projectiles + @enemies).each do |object|
      object.update
    end
    current_round.send_enemy if current_round && current_round.running?
  end

  def draw
    (@towers + @enemies + @projectiles).reverse.each do |object|
      object.draw
    end

    @font.draw("Enemies: #{@enemies.size}", 540, 10, 0, 1.0, 1.0, 0xffffff00)
    @font.draw("Moneys: #{@credits}", 10, 10, 0, 1.0, 1.0, 0xffffff00)

    if @enemies_exited > 0
      @font.draw("Enemies Exited: #{@enemies_exited}", 480, 450, 0, 1.0, 1.0, 0xffffff00)
    end
    
    if round_completed?
      text = 
        if @rounds.size > 0
          "Round Finished, press space to start next round"
        else
          "Press the space bar to start the flood of enemies"
        end

      @font.draw(text, 120, 240, 0, 1.0, 1.0, 0xffffff00)
    end
    
    if @potential_tower
      @potential_tower.x = mouse_x
      @potential_tower.y = mouse_y
      @potential_tower.place
      @potential_tower.draw(0.5)
    end
    @cursor.draw(mouse_x, mouse_y, 0)
  end

  def button_down(id)
    case id
    when Gosu::Button::KbEscape
      close
    when Gosu::Button::KbSpace
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
    @enemies << Enemy.new(self, rand(640), 0)
  end
  
  def current_round
    @rounds.last
  end
    
  def place_tower(m_x, m_y)
    tower = Tower.new(self, m_x, m_y, 150)
    if @credits >= tower.cost
      @credits = @credits - tower.cost
      @towers << tower
    end
  end
  
  def setup_basic_towers
    @towers << Tower.new(self, 200, 100, 150)
    @towers << Tower.new(self, 100, 300, 150)
    @towers << Tower.new(self, 400, 370, 150)
    @towers << Tower.new(self, 500, 220, 150)
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
    @enemies.delete(enemy)
    @credits += enemy.credit_value
  end
  
  def remove_projectile(projectile)
    @projectiles.delete(projectile)
  end
  
  def increment_enemies_exited
    @enemies_exited += 1
  end
  
  def font
    @font
  end
end
