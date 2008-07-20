class Round
  attr_accessor :enemies_sent
  
  def initialize(window, number, &block)
    @window = window
    @number = number
    @started = false
    @ended = false
    @enemies_sent = 0
    @send_enemy = block
    @send_enemy_counter = 0
  end
  
  def enemy_count
    4 + @number * 2
  end
  
  def send_enemy
    if send_enemy_now?
      @send_enemy.call
      self.enemies_sent += 1
      end! if all_enemies_sent?
    end
    @send_enemy_counter += 1
  end
  
  def send_enemy_now?
    # Need to use a Timer!
    @send_enemy_counter >= time_per_enemy && @send_enemy_counter = 0
  end
  
  def time_per_enemy
    60 / @number + 15
  end
  
  def all_enemies_sent?
    enemies_sent >= enemy_count
  end
  
  def start!
    @started = true
  end

  def started?
    @started == true
  end
  
  def end!
    @ended = true if started?
  end
  
  def ended?
    @ended == true
  end
  
  def running?
    started? && !ended?
  end
end
