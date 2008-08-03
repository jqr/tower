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
    4 + @number * 2 + 100000
  end
  
  def send_enemy
    if running?
      @send_enemy.call
      @last_enemy_sent_at = @window.wall_time
      self.enemies_sent += 1
      end! if all_enemies_sent?
    end
    @send_enemy_counter += 1
  end
  
  def send_enemy_now?
    @window.wall_time - @last_enemy_sent_at.to_i >= time_per_enemy && @send_enemy_counter = 0
  end
  
  def time_per_enemy
    extra = 
      if @number < 10
        (10 - @number)
      else
        0
      end
      
    200 + extra * 150
  end
  
  def all_enemies_sent?
    enemies_sent >= enemy_count
  end
  
  def start!
    @started = @window.wall_time
  end

  def started?
    @started
  end
  
  def end!
    @ended = @window.wall_time if started?
  end
  
  def ended?
    @ended
  end
  
  def running?
    started? && !ended?
  end
end
